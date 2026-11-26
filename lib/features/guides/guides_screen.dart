import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/mk_card.dart';
import 'guide_card.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  String? _categoryId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final categories = state.repo.categories
        .where((c) => state.repo.guides.any((g) => g.categoryId == c.id))
        .toList();
    final guides = state.repo.guides
        .where((g) => _categoryId == null || g.categoryId == _categoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Miongozo ya kilimo'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.lg),
            child: Icon(Icons.offline_pin_rounded, color: AppColors.success),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          MkCard(
            color: AppColors.primarySoft,
            borderColor: const Color(0xFFD8EBC8),
            shadow: AppShadows.soft,
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_download_outlined,
                  color: AppColors.primaryDark,
                  size: 26,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Soma bila mtandao', style: AppText.h3),
                      const SizedBox(height: 2),
                      Text(
                        'Miongozo yote inahifadhiwa kwenye simu yako — itumike shambani popote.',
                        style: AppText.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: const Text('Zote'),
                    selected: _categoryId == null,
                    onSelected: (_) => setState(() => _categoryId = null),
                  ),
                ),
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(category.name),
                      selected: _categoryId == category.id,
                      onSelected: (_) =>
                          setState(() => _categoryId = category.id),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final guide in guides) ...[
            GuideCard(guide: guide),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
