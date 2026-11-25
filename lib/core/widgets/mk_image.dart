import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Asset-backed agricultural image with a graceful, branded fallback.
///
/// Keeping the fallback means the interface never breaks when an image is
/// missing, slow or blocked — an important offline-friendliness property.
class MkImage extends StatelessWidget {
  const MkImage({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.agriculture_rounded,
    this.alignment = Alignment.center,
  });

  final String asset;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stack) => _Fallback(icon: fallbackIcon),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.softGradient),
      child: Center(
        child: Icon(
          icon,
          size: 34,
          color: AppColors.primary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

/// Circular farmer avatar with optional verified marker and image support.
class FarmerAvatar extends StatelessWidget {
  const FarmerAvatar({
    super.key,
    required this.initials,
    this.size = 44,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.icon,
  });

  final String initials;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: icon == null
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              )
            : null,
        color: icon == null ? null : backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: icon != null
          ? Icon(icon, size: size * 0.46, color: foregroundColor)
          : Text(
              initials,
              style: TextStyle(
                color: foregroundColor,
                fontSize: size * 0.34,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}
