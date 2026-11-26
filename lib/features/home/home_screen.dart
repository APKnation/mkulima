import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../core/widgets/mk_search_field.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/category.dart';
import '../../data/seed/misc_seed.dart';
import '../categories/category_detail_screen.dart';
import '../farm/farm_screen.dart';
import '../guides/guides_screen.dart';
import '../marketplace/product_detail_screen.dart';
import '../marketplace/search_screen.dart';
import '../prices/price_widgets.dart';
import '../prices/prices_screen.dart';
import '../profile/notifications_screen.dart';
import '../weather/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onOpenProfile});

  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final weather = weatherSeed;
    final categories = state.repo.categories;
    final featured = state.products.where((p) => p.verified).take(6).toList();
    final prices = state.repo.prices.take(3).toList();
    final farm = state.farm;
    final pendingTasks = farm.tasks.where((t) => !t.done).length;
    final viewed = state.recentlyViewedProducts;
    final recommended = state.products.skip(4).take(3).toList();

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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onOpenProfile,
                      child: FarmerAvatar(
                        initials: initialsOf(state.user.name),
                        size: 46,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(greetingForNow(), style: AppText.small),
                          Text(
                            state.user.firstName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.h2,
                          ),
                        ],
                      ),
                    ),
                    MkIconButton(
                      icon: Icons.notifications_none_rounded,
                      background: AppColors.surface,
                      badgeCount: state.unreadNotifications,
                      onTap: () =>
                          pushScreen(context, const NotificationsScreen()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkSearchLauncher(
                  onTap: () => pushScreen(context, const SearchScreen()),
                  onFilter: () =>
                      pushScreen(context, const SearchScreen(openFilters: true)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: GestureDetector(
                  onTap: () => pushScreen(context, const WeatherScreen()),
                  child: GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.wb_sunny_rounded,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              weather.location,
                              style: AppText.label.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  '${weather.temperature}°',
                                  style: AppText.display.copyWith(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          weather.summary,
                          style: AppText.body.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            _HeroChip(
                              icon: Icons.water_drop_outlined,
                              label: 'Mvua ${weather.rainChance}%',
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _HeroChip(
                              icon: Icons.air_rounded,
                              label: 'Upepo ${weather.windKph} km/h',
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _HeroChip(
                              icon: Icons.thermostat_rounded,
                              label: '${weather.humidity}% unyevu',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.payments_rounded,
                        label: 'Mauzo ya mwezi',
                        value: formatTsh(farm.monthlySales),
                        background: AppColors.primarySoft,
                        foreground: AppColors.primaryDark,
                        onTap: () => pushScreen(context, const FarmScreen()),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.task_alt_rounded,
                        label: 'Kazi zinazosubiri',
                        value: '$pendingTasks kati ya ${farm.tasks.length}',
                        background: AppColors.accentSoft,
                        foreground: const Color(0xFF8A6205),
                        onTap: () => pushScreen(context, const FarmScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(title: 'Kategoria za kilimo'),
              SizedBox(
                height: 104,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.page,
                  ),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) => _CategoryBubble(
                    category: categories[index],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: Row(
                  children: [
                    Expanded(
                      child: QuickActionTile(
                        icon: Icons.show_chart_rounded,
                        label: 'Bei za soko',
                        color: AppColors.successSoft,
                        foreground: AppColors.success,
                        onTap: () => pushScreen(context, const PricesScreen()),
                      ),
                    ),
                    Expanded(
                      child: QuickActionTile(
                        icon: Icons.menu_book_rounded,
                        label: 'Miongozo',
                        color: AppColors.infoSoft,
                        foreground: AppColors.info,
                        onTap: () => pushScreen(context, const GuidesScreen()),
                      ),
                    ),
                    Expanded(
                      child: QuickActionTile(
                        icon: Icons.agriculture_rounded,
                        label: 'Shamba langu',
                        color: AppColors.primarySoft,
                        foreground: AppColors.primaryDark,
                        onTap: () => pushScreen(context, const FarmScreen()),
                      ),
                    ),
                    Expanded(
                      child: QuickActionTile(
                        icon: Icons.wb_cloudy_rounded,
                        label: 'Hali ya hewa',
                        color: AppColors.turquoiseSoft,
                        foreground: const Color(0xFF00806A),
                        onTap: () => pushScreen(context, const WeatherScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SectionHeader(
                title: 'Bidhaa zilizoangaziwa',
                subtitle: 'Kutoka kwa wakulima waliothibitishwa',
                actionLabel: 'Zote',
                onAction: () => pushScreen(context, const SearchScreen()),
              ),
              SizedBox(
                height: 216,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.page,
                  ),
                  itemCount: featured.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final product = featured[index];
                    return SizedBox(
                      width: 164,
                      child: ProductGridCard(
                        product: product,
                        onTap: () => pushScreen(
                          context,
                          ProductDetailScreen(product: product),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              SectionHeader(
                title: 'Bei za soko leo',
                subtitle: 'Imesasishwa ${todayLabel()}',
                actionLabel: 'Bei zote',
                onAction: () => pushScreen(context, const PricesScreen()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkCard(
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
                          showDivider: i != prices.length - 1,
                          onTap: () =>
                              pushScreen(context, const PricesScreen()),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: MkCard(
                  color: AppColors.accentSoft,
                  borderColor: const Color(0xFFF2E2B4),
                  shadow: AppShadows.soft,
                  onTap: () => pushScreen(context, const GuidesScreen()),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
                          color: Color(0xFF3B2A02),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kidokezo cha leo',
                              style: AppText.overline.copyWith(
                                color: const Color(0xFF8A6205),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.repo.guides.first.tips.first,
                              style: AppText.body.copyWith(color: AppColors.ink),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Soma mwongozo →',
                              style: AppText.label.copyWith(
                                color: const Color(0xFF8A6205),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (viewed.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                const SectionHeader(title: 'Ulioangalia hivi karibuni'),
                SizedBox(
                  height: 216,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.page,
                    ),
                    itemCount: viewed.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = viewed[index];
                      return SizedBox(
                        width: 164,
                        child: ProductGridCard(
                          product: product,
                          onTap: () => pushScreen(
                            context,
                            ProductDetailScreen(product: product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              SectionHeader(
                title: 'Inapendekezwa kwako',
                subtitle: 'Kulingana na shughuli zako',
                actionLabel: 'Zaidi',
                onAction: () => pushScreen(context, const SearchScreen()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: Column(
                  children: [
                    for (final product in recommended) ...[
                      ProductCard(
                        product: product,
                        favorite: state.isFavorite(product.id),
                        onFavorite: () => state.toggleFavorite(product.id),
                        onTap: () => pushScreen(
                          context,
                          ProductDetailScreen(product: product),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.small.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      onTap: onTap,
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: foreground),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppText.small),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.h3.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _CategoryBubble extends StatelessWidget {
  const _CategoryBubble({required this.category});

  final AgriCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => pushScreen(
          context,
          CategoryDetailScreen(categoryId: category.id),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: SizedBox(
                width: 66,
                height: 66,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MkImage(asset: category.imageAsset, fit: BoxFit.cover),
                    Container(color: category.tint.withValues(alpha: 0.16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppText.label.copyWith(fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }
}
