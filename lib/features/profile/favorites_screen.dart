import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/product_card.dart';
import '../marketplace/search_screen.dart';
import '../marketplace/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final favorites = state.favoriteProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('Vipendwa')),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        color: AppColors.dangerSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 38,
                        color: AppColors.danger,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Huna bidhaa zilizohifadhiwa', style: AppText.h3),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Gusa alama ya moyo kwenye bidhaa yoyote ili kuihifadhi hapa.',
                      textAlign: TextAlign.center,
                      style: AppText.body,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: 220,
                      child: MkButton(
                        label: 'Vinjari soko',
                        icon: Icons.storefront_rounded,
                        onPressed: () =>
                            pushScreen(context, const SearchScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.page),
              children: [
                Text(
                  'Bidhaa ${favorites.length} zilizohifadhiwa',
                  style: AppText.small,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final product in favorites) ...[
                  ProductCard(
                    product: product,
                    favorite: true,
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
    );
  }
}
