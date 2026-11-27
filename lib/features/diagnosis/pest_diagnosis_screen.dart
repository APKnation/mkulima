import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/agri_tools.dart';
import '../../data/seed/agri_tools_seed.dart';

class PestDiagnosisScreen extends StatefulWidget {
  const PestDiagnosisScreen({super.key});

  @override
  State<PestDiagnosisScreen> createState() => _PestDiagnosisScreenState();
}

class _PestDiagnosisScreenState extends State<PestDiagnosisScreen> {
  String? _selectedCrop;
  String? _selectedType;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = cropPestsDiseasesSeed.where((item) {
      if (_selectedCrop != null && item.crop != _selectedCrop) return false;
      if (_selectedType != null && item.type != _selectedType) return false;
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        final matchName = item.name.toLowerCase().contains(q);
        final matchCrop = item.crop.toLowerCase().contains(q);
        final matchSymptoms = item.symptoms.any((s) => s.toLowerCase().contains(q));
        return matchName || matchCrop || matchSymptoms;
      }
      return true;
    }).toList();

    final crops = cropPestsDiseasesSeed.map((e) => e.crop).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magonjwa na Wadudu'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          // AI Diagnosis prompt card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.secondary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Utambuzi wa Picha (AI Scanner)',
                        style: AppText.bodyStrong.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Piga picha jani au tunda lililoathirika ili kupata utambuzi na dawa sahihi papo hapo.',
                        style: AppText.small.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tafuta ugonjwa au dalili (k.m. madoa, funza)...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
            onChanged: (val) => setState(() => _query = val.trim()),
          ),
          const SizedBox(height: AppSpacing.md),

          // Crop Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Mazao Yote'),
                  selected: _selectedCrop == null,
                  onSelected: (_) => setState(() => _selectedCrop = null),
                ),
                const SizedBox(width: AppSpacing.sm),
                for (final crop in crops) ...[
                  FilterChip(
                    label: Text(crop),
                    selected: _selectedCrop == crop,
                    onSelected: (_) => setState(() => _selectedCrop = crop),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Results list
          Text(
            'Magonjwa na Wadudu Walioorodheshwa (${filtered.length})',
            style: AppText.small,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final item in filtered) ...[
            _PestDiseaseCard(
              item: item,
              onTap: () => pushScreen(context, _PestDetailPage(item: item)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _PestDiseaseCard extends StatelessWidget {
  const _PestDiseaseCard({required this.item, required this.onTap});

  final CropPestDisease item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDanger = item.severity == 'Hatari kubwa';

    return MkCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 80,
              height: 80,
              child: MkImage(asset: item.imageAsset),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MkPill(
                      label: item.crop,
                      foreground: AppColors.primaryDeep,
                      background: AppColors.primarySoft,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    MkPill(
                      label: item.severity,
                      foreground: isDanger ? AppColors.danger : AppColors.accent,
                      background: isDanger ? AppColors.dangerSoft : AppColors.accentSoft,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: AppText.h3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.symptoms.first,
                  style: AppText.small,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PestDetailPage extends StatelessWidget {
  const _PestDetailPage({required this.item});

  final CropPestDisease item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: MkImage(asset: item.imageAsset),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              MkPill(
                label: 'Zao: ${item.crop}',
                foreground: AppColors.primaryDark,
                background: AppColors.primarySoft,
              ),
              const SizedBox(width: AppSpacing.sm),
              MkPill(
                label: item.type,
                foreground: AppColors.ink,
                background: AppColors.surfaceAlt,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(item.name, style: AppText.h1),
          const SizedBox(height: AppSpacing.lg),

          Text('Dalili Kuu Shambani', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            shadow: AppShadows.soft,
            child: Column(
              children: [
                for (final s in item.symptoms)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(s, style: AppText.body)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Matibabu ya Dawa za Dukani (Chemical)', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            color: AppColors.primarySoft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.medication_liquid_rounded, color: AppColors.primaryDark),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(item.solutionChemical, style: AppText.body),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Tiba Asili / Kienyeji (Organic)', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            color: AppColors.surfaceAlt,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.eco_rounded, color: AppColors.success),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(item.solutionOrganic, style: AppText.body),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Ushauri wa Kuzuia (Prevention)', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            shadow: AppShadows.soft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.accent),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(item.preventionTip, style: AppText.body),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
