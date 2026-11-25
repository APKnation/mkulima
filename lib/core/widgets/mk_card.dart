import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Standard rounded surface used for every content block.
class MkCard extends StatelessWidget {
  const MkCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.onTap,
    this.color = AppColors.surface,
    this.borderColor,
    this.radius = AppRadius.lg,
    this.shadow = AppShadows.card,
    this.clip = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color color;
  final Color? borderColor;
  final double radius;
  final List<BoxShadow> shadow;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = InkWell(onTap: onTap, child: content);
    }
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: shadow,
      ),
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: Material(
        color: Colors.transparent,
        child: content,
      ),
    );
  }
}

/// Featured hero surface with a subtle glass overlay, used sparingly.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppRadius.xl,
    this.gradient = AppColors.heroGradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: AppShadows.floating,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -46,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// Small labelled container used in "quick action" rows.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.primarySoft,
    this.foreground = AppColors.primaryDark,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: foreground, size: 26),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.label.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}
