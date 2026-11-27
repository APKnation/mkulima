import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_search_field.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/product.dart';
import 'create_listing_screen.dart';
import 'my_listings_screen.dart';
import 'product_detail_screen.dart';
import 'search_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String? _categoryId;
  ProductSort _sort = ProductSort.newest;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final categories = state.repo.categories;
    final filter = ProductFilter(categoryId: _categoryId, sort: _sort);
    final products = state.filter(filter);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'marketplace-create-listing',
        onPressed: () => pushScreen(context, const CreateListingScreen()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tangaza bidhaa'),
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.lg,
                  AppSpacing.page,
                  AppSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Soko la Mkulima', style: AppText.display),
                          const SizedBox(height: 2),
                          Text(
                            'Bidhaa ${products.length} kutoka kote Tanzania',
                            style: AppText.body,
                          ),
                        ],
                      ),
                    ),
                    MkIconButton(
                      icon: Icons.inventory_2_outlined,
                      tooltip: 'Bidhaa zangu',
                      onTap: () =>
                          pushScreen(context, const MyListingsScreen()),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkSearchLauncher(
                  onTap: () => pushScreen(context, const SearchScreen()),
                  hint: 'Tafuta mahindi, kuku, mbolea...',
                  onFilter: () =>
                      pushScreen(context, const SearchScreen(openFilters: true)),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 62,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.lg,
                    AppSpacing.page,
                    AppSpacing.sm,
                  ),
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  0,
                  AppSpacing.page,
                  AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Text(
                      '${products.length} bidhaa',
                      style: AppText.small,
                    ),
                    const Spacer(),
                    PopupMenuButton<ProductSort>(
                      initialValue: _sort,
                      onSelected: (value) => setState(() => _sort = value),
                      itemBuilder: (context) => [
                        for (final sort in ProductSort.values)
                          PopupMenuItem(value: sort, child: Text(sort.label)),
                      ],
                      child: Row(
                        children: [
                          const Icon(
                            Icons.swap_vert_rounded,
                            size: 17,
                            color: AppColors.primaryDark,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _sort.label,
                            style: AppText.label.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyMarketplace(
                  onCreate: () =>
                      pushScreen(context, const CreateListingScreen()),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  0,
                  AppSpacing.page,
                  110,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 210,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.74,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ProductGridCard(
                        product: product,
                        favorite: state.isFavorite(product.id),
                        onFavorite: () => state.toggleFavorite(product.id),
                        onTap: () => pushScreen(
                          context,
                          ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMarketplace extends StatelessWidget {
  const _EmptyMarketplace({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 48,
              color: AppColors.muted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Hakuna bidhaa kwenye kategoria hii', style: AppText.h3),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Kuwa wa kwanza kutangaza bidhaa yako.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tangaza bidhaa'),
            ),
          ],
        ),
      ),
    );
  }
}
