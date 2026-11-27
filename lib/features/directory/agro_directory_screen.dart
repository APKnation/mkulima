import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/agri_tools.dart';
import '../../data/seed/agri_tools_seed.dart';
import '../../data/seed/misc_seed.dart';

class AgroDirectoryScreen extends StatefulWidget {
  const AgroDirectoryScreen({super.key});

  @override
  State<AgroDirectoryScreen> createState() => _AgroDirectoryScreenState();
}

class _AgroDirectoryScreenState extends State<AgroDirectoryScreen> {
  String? _selectedRegion;
  String _selectedTab = 'Wote'; // 'Wote', 'Maduka', 'Maafisa Ugani'

  @override
  Widget build(BuildContext context) {
    final filtered = agroDealersSeed.where((d) {
      if (_selectedRegion != null && d.region != _selectedRegion) return false;
      if (_selectedTab == 'Maduka' && d.type != 'Muuzaji Pembejeo') return false;
      if (_selectedTab == 'Maafisa Ugani' && d.type != 'Afisa Ugani') return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maduka na Maafisa Ugani'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          // Header info
          Text(
            'Wasiliana na wauzaji wa pembejeo walioidhinishwa na maafisa ugani wa serikali karibu nawe.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),

          // Region Dropdown Filter
          DropdownButtonFormField<String?>(
            initialValue: _selectedRegion,
            decoration: const InputDecoration(
              labelText: 'Chuja kwa Mkoa',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Mikoa Yote')),
              for (final r in regionsSeed)
                DropdownMenuItem(value: r, child: Text(r)),
            ],
            onChanged: (val) => setState(() => _selectedRegion = val),
          ),
          const SizedBox(height: AppSpacing.md),

          // Filter tabs
          Row(
            children: [
              for (final tab in ['Wote', 'Maduka', 'Maafisa Ugani']) ...[
                ChoiceChip(
                  label: Text(tab),
                  selected: _selectedTab == tab,
                  onSelected: (_) => setState(() => _selectedTab = tab),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Count
          Text(
            'Matokeo yaliyopatikana (${filtered.length})',
            style: AppText.small,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Dealers list
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Center(
                child: Text('Hakuna mtaalamu aliyepatikana kwa mkoa huu.'),
              ),
            )
          else
            for (final d in filtered) ...[
              _DealerCard(dealer: d),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _DealerCard extends StatelessWidget {
  const _DealerCard({required this.dealer});

  final AgroDealer dealer;

  @override
  Widget build(BuildContext context) {
    final isOfficer = dealer.type == 'Afisa Ugani';

    return MkCard(
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isOfficer ? AppColors.infoSoft : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  isOfficer ? Icons.support_agent_rounded : Icons.storefront_rounded,
                  color: isOfficer ? AppColors.info : AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(dealer.name, style: AppText.h3),
                        ),
                        if (dealer.verified)
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${dealer.type} · ${dealer.district}, ${dealer.region}',
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(dealer.location, style: AppText.small),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final spec in dealer.specialties)
                MkPill(
                  label: spec,
                  foreground: AppColors.ink,
                  background: AppColors.surfaceAlt,
                ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: MkButton(
                  label: 'Piga Simu (${dealer.phone})',
                  icon: Icons.phone_rounded,
                  height: 44,
                  onPressed: () {
                    showAppSnack(
                      context,
                      'Inapiga simu kwa ${dealer.name}: ${dealer.phone}',
                      icon: Icons.phone_in_talk_rounded,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
