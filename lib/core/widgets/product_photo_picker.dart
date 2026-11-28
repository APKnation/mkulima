import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../utils/ui_helpers.dart';

class _DemoPhotoOption {
  const _DemoPhotoOption({
    required this.asset,
    required this.label,
    required this.icon,
  });

  final String asset;
  final String label;
  final IconData icon;
}

const _demoPhotoOptions = [
  _DemoPhotoOption(
    asset: 'assets/images/cereals.jpg',
    label: 'Nafaka & Mahindi',
    icon: Icons.grass_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/vegetables.jpg',
    label: 'Mbogamboga',
    icon: Icons.eco_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/fruits.jpg',
    label: 'Matunda',
    icon: Icons.park_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/food.jpg',
    label: 'Mazao ya Chakula',
    icon: Icons.rice_bowl_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/livestock.jpg',
    label: 'Mifugo',
    icon: Icons.pets_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/poultry.jpg',
    label: 'Kuku & Mayai',
    icon: Icons.egg_alt_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/fisheries.jpg',
    label: 'Samaki',
    icon: Icons.set_meal_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/inputs.jpg',
    label: 'Pembejeo & Mbolea',
    icon: Icons.science_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/mkulima1.jpg',
    label: 'Shambani (Picha 1)',
    icon: Icons.photo_camera_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/mkulima2.jpg',
    label: 'Sokoni (Picha 2)',
    icon: Icons.storefront_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/mkulima3.jpg',
    label: 'Mavuno (Picha 3)',
    icon: Icons.agriculture_rounded,
  ),
  _DemoPhotoOption(
    asset: 'assets/images/other.jpg',
    label: 'Bidhaa Nyingine',
    icon: Icons.inventory_2_rounded,
  ),
];

/// Interactive photo upload & preview card for crop/product listings.
class ProductPhotoPicker extends StatelessWidget {
  const ProductPhotoPicker({
    super.key,
    required this.selectedAsset,
    required this.onSelected,
    this.buttonLabel = 'Pakia picha ya zao',
  });

  final String? selectedAsset;
  final ValueChanged<String> onSelected;
  final String buttonLabel;

  Future<void> _openPicker(BuildContext context) async {
    final chosen = await showAppSheet<String>(
      context,
      child: Builder(
        builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            0,
            AppSpacing.page,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SheetHandle(),
              const SheetHeader(
                title: 'Pakia picha ya bidhaa',
                subtitle: 'Chagua picha ya zao au piga picha mpya',
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _SourceTile(
                      icon: Icons.camera_alt_rounded,
                      label: 'Kamera',
                      color: AppColors.primary,
                      onTap: () => Navigator.of(ctx).pop(
                        selectedAsset ?? 'assets/images/mkulima1.jpg',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _SourceTile(
                      icon: Icons.photo_library_rounded,
                      label: 'Galari',
                      color: AppColors.accent,
                      onTap: () => Navigator.of(ctx).pop(
                        selectedAsset ?? 'assets/images/cereals.jpg',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Au chagua picha ya mfano:',
                style: AppText.label.copyWith(color: AppColors.inkSoft),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 220,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: _demoPhotoOptions.length,
                  itemBuilder: (_, i) {
                    final opt = _demoPhotoOptions[i];
                    final active = opt.asset == selectedAsset;
                    return GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(opt.asset),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.line,
                            width: active ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppRadius.md - 1),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(opt.asset, fit: BoxFit.cover),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.72),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (active)
                                const Positioned(
                                  top: 6,
                                  right: 6,
                                  child: CircleAvatar(
                                    radius: 11,
                                    backgroundColor: AppColors.primary,
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Positioned(
                                left: 6,
                                right: 6,
                                bottom: 6,
                                child: Text(
                                  opt.label,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );

    if (chosen != null) {
      onSelected(chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = selectedAsset != null && selectedAsset!.isNotEmpty;

    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primarySoft.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: hasPhoto ? AppColors.primary : AppColors.line,
            width: hasPhoto ? 1.5 : 1.2,
          ),
        ),
        child: hasPhoto
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl - 1),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        selectedAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primarySoft,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        boxShadow: AppShadows.floating,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.camera_alt_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            buttonLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xxl,
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.soft,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      buttonLabel,
                      style: AppText.bodyStrong.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gusa hapa kuweka picha halisi ya mazao yako',
                      textAlign: TextAlign.center,
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppText.bodyStrong.copyWith(color: color, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
