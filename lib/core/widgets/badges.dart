import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Small rounded label used for statuses, tags and metadata.
class MkPill extends StatelessWidget {
  const MkPill({
    super.key,
    required this.label,
    this.icon,
    this.foreground = AppColors.primaryDark,
    this.background = AppColors.primarySoft,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.textStyle,
  });

  final String label;
  final IconData? icon;
  final Color foreground;
  final Color background;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: (textStyle ?? AppText.label).copyWith(
              color: foreground,
              fontSize: (textStyle?.fontSize ?? AppText.label.fontSize)! ,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Price movement indicator: green for up is not always good for farmers, so
/// we colour by direction only and always pair it with an arrow + label.
class ChangeBadge extends StatelessWidget {
  const ChangeBadge({
    super.key,
    required this.percent,
    this.compact = false,
    this.showLabel = false,
  });

  final double percent;
  final bool compact;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (percent == 0) {
      return MkPill(
        label: showLabel ? 'Hakuna mabadiliko' : '0%',
        foreground: AppColors.muted,
        background: AppColors.surfaceAlt,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 7 : 9,
          vertical: compact ? 3 : 5,
        ),
        icon: compact ? null : Icons.remove_rounded,
      );
    }
    final up = percent > 0;
    final color = up ? AppColors.success : AppColors.danger;
    final bg = up ? AppColors.successSoft : AppColors.dangerSoft;
    return MkPill(
      label: '${percent.abs().toStringAsFixed(1)}%',
      icon: up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
      foreground: color,
      background: bg,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 3 : 5,
      ),
    );
  }
}

/// Trust marker for verified farmers, co-operatives and experts.
class VerifiedChip extends StatelessWidget {
  const VerifiedChip({super.key, this.label = 'Amethibitishwa', this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified_rounded, size: 15, color: AppColors.info),
        if (!compact) ...[
          const SizedBox(width: 3),
          Text(
            label,
            style: AppText.label.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

/// Rating display with a star and a review count.
class RatingLabel extends StatelessWidget {
  const RatingLabel({
    super.key,
    required this.rating,
    this.reviews,
    this.compact = false,
  });

  final double rating;
  final int? reviews;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 15, color: AppColors.accent),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: AppText.label.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: compact ? 11.5 : null,
          ),
        ),
        if (!compact && reviews != null) ...[
          const SizedBox(width: 3),
          Text('($reviews)', style: AppText.small),
        ],
      ],
    );
  }
}

/// Offline availability marker for guides.
class OfflineChip extends StatelessWidget {
  const OfflineChip({super.key, this.saved = true});

  final bool saved;

  @override
  Widget build(BuildContext context) {
    return MkPill(
      label: saved ? 'Imehifadhiwa' : 'Nje ya mtandao',
      icon: saved ? Icons.offline_pin_rounded : Icons.cloud_download_outlined,
      foreground: saved ? AppColors.success : AppColors.inkSoft,
      background: saved ? AppColors.successSoft : AppColors.surfaceAlt,
    );
  }
}
