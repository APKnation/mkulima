import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/product_card.dart';
import 'create_listing_screen.dart';
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
            tooltip: 'Tangaza bidhaa',
            onPressed: () => pushScreen(context, const CreateListingScreen()),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: listings.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: AppColors.muted,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Huna bidhaa iliyotangazwa', style: AppText.h3),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tangaza bidhaa yako ya kwanza ili wanunuzi wakupate.',
                      textAlign: TextAlign.center,
                      style: AppText.body,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton.icon(
                      onPressed: () =>
                          pushScreen(context, const CreateListingScreen()),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Tangaza bidhaa'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.page),
              children: [
                for (final product in listings) ...[
                  Dismissible(
                    key: ValueKey(product.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) => showConfirmDialog(
                      context,
                      title: 'Ondoa bidhaa?',
                      message:
                          '${product.name} itaondolewa sokoni. Unaweza kutangaza tena baadaye.',
                      confirmLabel: 'Ondoa',
                      destructive: true,
                    ),
                    onDismissed: (_) {
                      state.removeProduct(product.id);
                      showAppSnack(context, 'Bidhaa imeondolewa');
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.xl),
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.dangerSoft,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.danger,
                      ),
                    ),
                    child: ProductCard(
                      product: product,
                      onTap: () => pushScreen(
                        context,
                        ProductDetailScreen(product: product),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text(
                  'Telezesha bidhaa kushoto kuiondoa.',
                  textAlign: TextAlign.center,
                  style: AppText.small,
                ),
              ],
            ),
    );
  }
}
