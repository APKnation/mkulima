import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/product.dart';
import 'create_listing_screen.dart';
import 'edit_listing_screen.dart';
import 'product_detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final listings = state.myListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bidhaa zangu'),
        actions: [
          IconButton(
            tooltip: 'Tangaza bidhaa mpya',
            onPressed: () => pushScreen(context, const CreateListingScreen()),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: listings.isEmpty
          ? _EmptyState(
              onAdd: () => pushScreen(context, const CreateListingScreen()),
            )
          : Column(
              children: [
                // Stats ribbon
                _StatsRibbon(listings: listings),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.md,
                      AppSpacing.page,
                      AppSpacing.xxxl,
                    ),
                    itemCount: listings.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = listings[index];
                      return _ListingCard(product: product);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: listings.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () =>
                  pushScreen(context, const CreateListingScreen()),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tangaza'),
            )
          : null,
    );
  }
}

// ── Stats ribbon ─────────────────────────────────────────────────────────────

class _StatsRibbon extends StatelessWidget {
  const _StatsRibbon({required this.listings});
  final List<Product> listings;

  @override
  Widget build(BuildContext context) {
    final total = listings.length;
    final active = listings.where((p) => p.available).length;
    final totalValue = listings.fold<double>(0, (s, p) => s + p.price);

    return Container(
      color: AppColors.primarySoft,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.page,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          _StatChip(
            label: 'Bidhaa',
            value: '$total',
            icon: Icons.inventory_2_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          _StatChip(
            label: 'Zinauzwa',
            value: '$active',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.md),
          _StatChip(
            label: 'Jumla ya Bei',
            value: formatTsh(totalValue),
            icon: Icons.payments_outlined,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppText.bodyStrong.copyWith(
                      color: color,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(label, style: AppText.small.copyWith(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Individual listing card ───────────────────────────────────────────────────

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showConfirmDialog(
        context,
        title: 'Ondoa bidhaa?',
        message:
            '${product.name} itaondolewa sokoni kabisa. Huwezi kuirejesha.',
        confirmLabel: 'Ondoa',
        destructive: true,
      ),
      onDismissed: (_) {
        state.removeProduct(product.id);
        showAppSnack(context, '${product.name} imeondolewa');
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.dangerSoft,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            SizedBox(height: 4),
            Text(
              'Ondoa',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      child: MkCard(
        onTap: () => pushScreen(context, ProductDetailScreen(product: product)),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + status badge row
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                    child: Image.asset(
                      product.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primarySoft,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppRadius.lg),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status badge top-left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _StatusBadge(available: product.available),
                  ),
                  // Edit button top-right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _EditIconButton(
                      onPressed: () async {
                        final updated = await pushScreen<Product>(
                          context,
                          EditListingScreen(product: product),
                        );
                        if (updated != null && context.mounted) {
                          AppScope.read(context).updateProduct(updated);
                          showAppSnack(context, 'Bidhaa imesasishwa ✓');
                        }
                      },
                    ),
                  ),
                  // Price bottom-left
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        product.priceLabel,
                        style: AppText.label.copyWith(
                          color: AppColors.primaryDeep,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppText.bodyStrong,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.organic)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.turquoiseSoft,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco_rounded,
                                  size: 11, color: AppColors.turquoise),
                              const SizedBox(width: 3),
                              Text(
                                'Asilia',
                                style: AppText.label.copyWith(
                                  color: AppColors.turquoise,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined,
                          size: 13, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(
                        product.quantityLabel,
                        style: AppText.small,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.locationLine,
                          style: AppText.small,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Action row
                  Row(
                    children: [
                      Expanded(
                        child: MkButton(
                          label: 'Hariri',
                          icon: Icons.edit_outlined,
                          variant: MkButtonVariant.outline,
                          height: 38,
                          onPressed: () async {
                            final updated = await pushScreen<Product>(
                              context,
                              EditListingScreen(product: product),
                            );
                            if (updated != null && context.mounted) {
                              AppScope.read(context).updateProduct(updated);
                              showAppSnack(context, 'Bidhaa imesasishwa ✓');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: MkButton(
                          label: product.available ? 'Simamisha' : 'Uza tena',
                          icon: product.available
                              ? Icons.pause_circle_outline_rounded
                              : Icons.play_circle_outline_rounded,
                          variant: MkButtonVariant.soft,
                          height: 38,
                          onPressed: () {
                            final updated = product.copyWith(
                              available: !product.available,
                            );
                            state.updateProduct(updated);
                            showAppSnack(
                              context,
                              updated.available
                                  ? '${product.name} inauzwa sasa'
                                  : '${product.name} imesimamishwa',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        tooltip: 'Futa bidhaa',
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.dangerSoft,
                          foregroundColor: AppColors.danger,
                        ),
                        onPressed: () async {
                          final confirm = await showConfirmDialog(
                            context,
                            title: 'Ondoa bidhaa?',
                            message:
                                '${product.name} itaondolewa sokoni kabisa.',
                            confirmLabel: 'Ondoa',
                            destructive: true,
                          );
                          if (confirm == true && context.mounted) {
                            state.removeProduct(product.id);
                            showAppSnack(context, '${product.name} imeondolewa');
                          }
                        },
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      ),
                    ],
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

// ── Small helpers ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.available});
  final bool available;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: available ? AppColors.success : AppColors.muted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available
                ? Icons.check_circle_rounded
                : Icons.pause_circle_outline_rounded,
            size: 11,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            available ? 'Inauzwa' : 'Imesimama',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditIconButton extends StatelessWidget {
  const _EditIconButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: AppShadows.soft,
        ),
        child: const Icon(Icons.edit_rounded, size: 17, color: AppColors.ink),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Bado huna bidhaa', style: AppText.h3),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tangaza mazao, mifugo au bidhaa yako na uanze kupata wanunuzi leo hii.',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(
              label: 'Tangaza bidhaa ya kwanza',
              icon: Icons.add_photo_alternate_rounded,
              onPressed: onAdd,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Inachukua dakika 2 tu',
              style: AppText.small.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
