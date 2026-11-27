import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/category.dart';
import '../guides/guide_card.dart';
import '../guides/guides_screen.dart';
import '../marketplace/product_detail_screen.dart';
import '../prices/price_widgets.dart';
import '../prices/prices_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String? _subcategoryId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final category = state.repo.category(widget.categoryId);
    if (category == null) {
      return const Scaffold(body: Center(child: Text('Kategoria haipatikani')));
    }

    final products = state.products
        .where((p) =>
            p.categoryId == category.id &&
            (_subcategoryId == null || p.subcategoryId == _subcategoryId))
        .toList();
    final guides =
        state.repo.guides.where((g) => g.categoryId == category.id).toList();
    final prices = state.repo.prices
        .where((p) => p.categoryId == category.id)
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            _Header(category: category),
            Material(
              color: AppColors.bg,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Bidhaa'),
                  Tab(text: 'Mwongozo'),
                  Tab(text: 'Bei'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ProductsTab(
                    category: category,
                    products: products,
                    selectedSubcategory: _subcategoryId,
                    onSubcategory: (id) => setState(
                      () => _subcategoryId = _subcategoryId == id ? null : id,
                    ),
                  ),
                  _GuidesTab(guides: guides),
                  _PricesTab(prices: prices, category: category),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.category});

  final AgriCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206,
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
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _RoundButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      MkPill(
                        label: '${category.listingCount} bidhaa',
                        icon: Icons.inventory_2_outlined,
                        foreground: Colors.white,
                        background: Colors.black.withValues(alpha: 0.32),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Icon(
                          category.icon,
                          color: AppColors.primaryDark,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.h1.copyWith(color: Colors.white),
                            ),
                            Text(
                              category.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.small.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 21, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({
    required this.category,
    required this.products,
    required this.selectedSubcategory,
    required this.onSubcategory,
  });

  final AgriCategory category;
  final List products;
  final String? selectedSubcategory;
  final ValueChanged<String> onSubcategory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xxxl,
      ),
      children: [
        Text(category.description, style: AppText.body),
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
                  selected: selectedSubcategory == null,
                  onSelected: (_) {
                    if (selectedSubcategory != null) {
                      onSubcategory(selectedSubcategory!);
                    }
                  },
                ),
              ),
              for (final sub in category.subcategories)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(sub.name),
                    selected: selectedSubcategory == sub.id,
                    onSelected: (_) => onSubcategory(sub.id),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (products.isEmpty)
          _EmptyCategory(
            title: 'Hakuna bidhaa kwa sasa',
            message:
                'Bidhaa za kategoria hii zitaonekana hapa mara zikiwekwa sokoni.',
            onAction: () => pushScreen(context, const GuidesScreen()),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 210,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.74,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductGridCard(
                product: product,
                favorite: AppScope.of(context).isFavorite(product.id),
                onFavorite: () =>
                    AppScope.read(context).toggleFavorite(product.id),
                onTap: () => pushScreen(
                  context,
                  ProductDetailScreen(product: product),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _GuidesTab extends StatelessWidget {
  const _GuidesTab({required this.guides});

  final List guides;

  @override
  Widget build(BuildContext context) {
    if (guides.isEmpty) {
      return const _EmptyCategory(
        title: 'Miongozo inakuja hivi karibuni',
        message: 'Tunafanya kazi na wataalamu kuandaa miongozo ya kategoria hii.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.page),
      itemCount: guides.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => GuideCard(guide: guides[index]),
    );
  }
}

class _PricesTab extends StatelessWidget {
  const _PricesTab({required this.prices, required this.category});

  final List prices;
  final AgriCategory category;

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return _EmptyCategory(
        title: 'Bei hazipatikani kwa sasa',
        message: 'Tutaruhusu bei za ${category.name} mara zinapowasilishwa.',
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xxxl,
      ),
      children: [
        MkPill(
          label: 'Bei zilizothibitishwa na maafisa wa soko',
          icon: Icons.verified_rounded,
          foreground: AppColors.success,
          background: AppColors.successSoft,
        ),
        const SizedBox(height: AppSpacing.md),
        MkCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            children: [
              for (var i = 0; i < prices.length; i++)
                PriceListTile(
                  commodity: prices[i].commodity,
                  market: prices[i].market,
                  region: prices[i].region,
                  retail: prices[i].retail,
                  unit: prices[i].unit,
                  changePercent: prices[i].changePercent,
                  trend: prices[i].trend,
                  sourceLabel: prices[i].sourceLabel,
                  showDivider: i != prices.length - 1,
                  onTap: () => pushScreen(context, const PricesScreen()),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory({
    required this.title,
    required this.message,
    this.onAction,
  });

  final String title;
  final String message;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.huge),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 34,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppText.h3),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.small,
            ),
          ),
          if (onAction != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: onAction, child: const Text('Vinjari miongozo')),
          ],
        ],
      ),
    );
  }
}
