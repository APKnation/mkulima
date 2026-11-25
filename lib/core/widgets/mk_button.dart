import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

enum MkButtonVariant { primary, outline, soft, gold, danger, ghost }

/// Primary action component. Large touch target, clear hierarchy.
class MkButton extends StatelessWidget {
  const MkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = MkButtonVariant.primary,
    this.expand = true,
    this.loading = false,
    this.height = 52,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final MkButtonVariant variant;
  final bool expand;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (variant) {
      MkButtonVariant.primary => (
          AppColors.primary,
          Colors.white,
          Colors.transparent,
        ),
      MkButtonVariant.outline => (
          Colors.transparent,
          AppColors.primaryDark,
          AppColors.line,
        ),
      MkButtonVariant.soft => (
          AppColors.primarySoft,
          AppColors.primaryDark,
          Colors.transparent,
        ),
      MkButtonVariant.gold => (
          AppColors.accent,
          const Color(0xFF3B2A02),
          Colors.transparent,
        ),
      MkButtonVariant.danger => (
          AppColors.dangerSoft,
          AppColors.danger,
          Colors.transparent,
        ),
      MkButtonVariant.ghost => (
          Colors.transparent,
          AppColors.inkSoft,
          Colors.transparent,
        ),
    };

    final enabled = onPressed != null && !loading;

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: fg),
          )
        else if (icon != null) ...[
          Icon(icon, size: 19, color: enabled ? fg : fg.withValues(alpha: 0.5)),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.button.copyWith(
              color: enabled ? fg : fg.withValues(alpha: 0.45),
            ),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: 19, color: enabled ? fg : fg.withValues(alpha: 0.5)),
        ],
      ],
    );

    return Padding(
      padding: EdgeInsets.zero,
      child: Material(
        color: enabled ? bg : bg.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: border, width: 1.4),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Compact circular icon button used in headers and on cards.
class MkIconButton extends StatelessWidget {
  const MkIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.background = AppColors.surface,
    this.foreground = AppColors.ink,
    this.size = 44,
    this.badgeCount,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;
  final double size;
  final int? badgeCount;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: size * 0.46, color: foreground),
              if (badgeCount != null && badgeCount! > 0)
                Positioned(
                  top: size * 0.18,
                  right: size * 0.18,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      badgeCount! > 9 ? '9+' : '$badgeCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 8,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3B2A02),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
