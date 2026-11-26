import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.read(context).markViewed(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final product = widget.product;
    final category = state.repo.category(product.categoryId);
    final similar = state.products
        .where((p) =>
            p.categoryId == product.categoryId && p.id != product.id)
        .take(4)
        .toList();
    final favorite = state.isFavorite(product.id);

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              MkIconButton(
                icon: favorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                foreground: favorite ? AppColors.danger : AppColors.inkSoft,
                onTap: () {
                  state.toggleFavorite(product.id);
                  showAppSnack(
                    context,
                    favorite
                        ? 'Bidhaa imeondolewa kwenye vipendwa'
                        : 'Bidhaa imehifadhiwa kwenye vipendwa',
                  );
                },
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: MkButton(
                  label: 'Wasiliana na mfuzaji',
                  icon: Icons.chat_bubble_outline_rounded,
                  onPressed: () => showAppSheet(
                    context,
                    child: _ContactSheet(product: product),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MkImage(asset: product.imageAsset),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.24),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.18),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.page),
                      child: Row(
                        children: [
                          _RoundButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          _RoundButton(
                            icon: Icons.share_outlined,
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text:
                                      '${product.name} — ${product.priceLabel} · ${product.locationLine} (Mkulima App)',
                                ),
                              );
                              showAppSnack(context, 'Taarifa ya bidhaa imenakiliwa');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.page,
                    bottom: AppSpacing.lg,
                    right: AppSpacing.page,
                    child: Row(
                      children: [
                        MkPill(
                          label: product.subcategoryName,
                          foreground: AppColors.primaryDeep,
                          background: Colors.white.withValues(alpha: 0.94),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        if (product.organic)
                          MkPill(
                            label: 'Asilia',
                            icon: Icons.eco_rounded,
                            foreground: AppColors.primaryDark,
                            background: Colors.white.withValues(alpha: 0.94),
                          ),
                        if (!product.available)
                          const MkPill(
                            label: 'Haipatikani',
                            foreground: AppColors.danger,
                            background: AppColors.dangerSoft,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppText.h1),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (product.reviewCount > 0) ...[
                        RatingLabel(
                          rating: product.rating,
                          reviews: product.reviewCount,
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      const Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 3),
                      Text('${product.views} wameona', style: AppText.small),
                      const Spacer(),
                      Text('Imechapishwa ${product.listedAt}',
                          style: AppText.small),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatTsh(product.price),
                        style: AppText.display.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 27,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('/ ${product.unit}', style: AppText.small),
                      ),
                      const Spacer(),
                      if (product.previousPrice != null)
                        Text(
                          formatTsh(product.previousPrice!),
                          style: AppText.small.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      if (product.negotiable)
                        const MkPill(
                          label: 'Bei inajadiliwa',
                          icon: Icons.handshake_outlined,
                        ),
                      if (product.negotiable) const SizedBox(width: AppSpacing.sm),
                      MkPill(
                        label: product.available ? 'Ipo sokoni' : 'Imeisha',
                        icon: product.available
                            ? Icons.check_circle_outline_rounded
                            : Icons.cancel_outlined,
                        foreground: product.available
                            ? AppColors.success
                            : AppColors.danger,
                        background: product.available
                            ? AppColors.successSoft
                            : AppColors.dangerSoft,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  MkCard(
                    shadow: AppShadows.soft,
                    child: Row(
                      children: [
                        Expanded(
                          child: _Info(
                            icon: Icons.inventory_2_outlined,
                            label: 'Kiasi kilichopo',
                            value: product.quantityLabel,
                          ),
                        ),
                        Container(width: 1, height: 40, color: AppColors.line),
                        Expanded(
                          child: _Info(
                            icon: Icons.shopping_basket_outlined,
                            label: 'Agizo la chini',
                            value: product.minOrder == null
                                ? 'Hakuna'
                                : '${product.minOrder} ${product.unit}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  MkCard(
                    shadow: AppShadows.soft,
                    onTap: () => showAppSheet(
                      context,
                      child: _ContactSheet(product: product),
                    ),
                    child: Row(
                      children: [
                        FarmerAvatar(
                          initials: initialsOf(product.sellerName),
                          size: 46,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      product.sellerName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.bodyStrong,
                                    ),
                                  ),
                                  if (product.verified) ...[
                                    const SizedBox(width: 4),
                                    const VerifiedChip(compact: true),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(product.sellerType, style: AppText.small),
                              Text(
                                product.locationLine,
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
                  const SizedBox(height: AppSpacing.xl),
                  Text('Maelezo ya bidhaa', style: AppText.h2),
                  const SizedBox(height: AppSpacing.sm),
                  Text(product.description, style: AppText.body),
                  const SizedBox(height: AppSpacing.lg),
                  if (category != null)
                    MkCard(
                      color: AppColors.surfaceAlt,
                      shadow: const [],
                      padding: const EdgeInsets.all(AppSpacing.md),
                      onTap: null,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 20, color: AppColors.primaryDark),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Kategoria: ${category.name} · ${product.subcategoryName}',
                              style: AppText.small,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          size: 19,
                          color: Color(0xFF8A6205),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Kutana na mfuzaji mahali palipo na watu, kagua bidhaa kabla ya malipo '
                            'na usitume pesa kwa njia isiyo rasmi.',
                            style: AppText.small.copyWith(
                              color: const Color(0xFF5C4305),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (similar.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Text('Bidhaa zinazofanana', style: AppText.h2),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 216,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: similar.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final item = similar[index];
                          return SizedBox(
                            width: 164,
                            child: ProductGridCard(
                              product: item,
                              onTap: () => pushScreen(
                                context,
                                ProductDetailScreen(product: item),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryDark),
        const SizedBox(height: 5),
        Text(label, style: AppText.small),
        const SizedBox(height: 2),
        Text(value, textAlign: TextAlign.center, style: AppText.label),
      ],
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
      color: Colors.white.withValues(alpha: 0.94),
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

class _ContactSheet extends StatefulWidget {
  const _ContactSheet({required this.product});

  final Product product;

  @override
  State<_ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends State<_ContactSheet> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: AppSpacing.lg),
            SheetHeader(
              title: product.sellerName,
              subtitle: '${product.sellerType} · ${product.locationLine}',
            ),
            const SizedBox(height: AppSpacing.lg),
            MkCard(
              color: AppColors.primarySoft,
              borderColor: const Color(0xFFD8EBC8),
              shadow: const [],
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(
                    Icons.phone_iphone_rounded,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      product.sellerPhone,
                      style: AppText.h3,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Nakili namba',
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: product.sellerPhone),
                      );
                      showAppSnack(context, 'Namba ya simu imenakiliwa');
                    },
                    icon: const Icon(Icons.copy_rounded, size: 19),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Tuma ujumbe kuhusu: ${product.name}', style: AppText.label),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _message,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Habari, nina nia ya kununua...',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            MkButton(
              label: 'Tuma ujumbe',
              icon: Icons.send_rounded,
              onPressed: () {
                if (_message.text.trim().length < 4) {
                  showAppSnack(
                    context,
                    'Andika ujumbe kwanza',
                    isError: true,
                    icon: Icons.error_outline_rounded,
                  );
                  return;
                }
                Navigator.of(context).pop();
                showAppSnack(context, 'Ujumbe wako umetumwa kwa mfuzaji');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: Text(
                'Majibu huja kwa ujumbe au simu. Hakikisha bidhaa kabla ya malipo.',
                textAlign: TextAlign.center,
                style: AppText.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
