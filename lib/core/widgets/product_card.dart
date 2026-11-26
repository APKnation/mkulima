import 'package:material_ui/material_ui.dart';

import '../../data/models/product.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'badges.dart';
import 'mk_card.dart';
import 'mk_image.dart';

/// Horizontal listing row used in search, favourites and category feeds.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavorite,
    this.favorite = false,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 92,
              height: 92,
              child: MkImage(asset: product.imageAsset),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.h3,
                      ),
                    ),
                    if (onFavorite != null)
                      InkWell(
                        onTap: onFavorite,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            favorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 19,
                            color: favorite
                                ? AppColors.danger
                                : AppColors.muted,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  product.subcategoryName,
                  style: AppText.small,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      formatTsh(product.price),
                      style: AppText.h3.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      ' / ${product.unit}',
                      style: AppText.small,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 13,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        product.locationLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.small,
                      ),
                    ),
                    if (product.verified) const VerifiedChip(compact: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical card used in two-column marketplace grids.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavorite,
    this.favorite = false,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MkImage(asset: product.imageAsset),
                if (onFavorite != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onFavorite,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            favorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: favorite
                                ? AppColors.danger
                                : AppColors.inkSoft,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (product.organic)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: MkPill(
                      label: 'Asilia',
                      icon: Icons.eco_rounded,
                      background: Colors.white.withValues(alpha: 0.92),
                      foreground: AppColors.primaryDark,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h3.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 2),
                Text(
                  product.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.small,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatTsh(product.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.h3.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 15.5,
                        ),
                      ),
                    ),
                    Text('/${product.unit}', style: AppText.small),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
