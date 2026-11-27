import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../core/widgets/mk_search_field.dart';
import '../../data/models/category.dart';
import '../guides/guides_screen.dart';
import '../marketplace/search_screen.dart';
import '../prices/prices_screen.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final categories = state.repo.categories;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.lg,
                  AppSpacing.page,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kategoria', style: AppText.display),
                    const SizedBox(height: 4),
                    Text(
                      'Chagua shughuli yako ya kilimo ili kupata bidhaa, bei na miongozo.',
                      style: AppText.body,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkSearchLauncher(
                  onTap: () => pushScreen(context, const SearchScreen()),
                  hint: 'Tafuta kategoria, zao au bidhaa',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (context, index) =>
                      CategoryTile(category: categories[index]),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkCard(
                  onTap: () => pushScreen(context, const GuidesScreen()),
                  color: AppColors.primaryDeep,
                  shadow: AppShadows.card,
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
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
                              'Miongozo ya kilimo',
                              style: AppText.h3.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Hatua kwa hatua kwa kila zao na mifugo',
                              style: AppText.small.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkCard(
                  onTap: () => pushScreen(context, const PricesScreen()),
                  shadow: AppShadows.soft,
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.successSoft,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.show_chart_rounded,
                          color: AppColors.success,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bei za soko', style: AppText.h3),
                            const SizedBox(height: 2),
                            Text(
                              'Bei za leo kutoka masoko mbalimbali',
                              style: AppText.small,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Image-backed category card used on the category grid.
class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, this.width, this.height});

  final AgriCategory category;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: MkCard(
        padding: EdgeInsets.zero,
        onTap: () => pushScreen(
          context,
          CategoryDetailScreen(categoryId: category.id),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MkImage(asset: category.imageAsset),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.66),
                  ],
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(category.icon, size: 19, color: AppColors.primaryDark),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.h3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${category.listingCount} bidhaa',
                    style: AppText.small.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
