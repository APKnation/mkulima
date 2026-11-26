import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/badges.dart';

/// Minimal trend line used for recent retail prices.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.width = 64,
    this.height = 32,
    this.color = AppColors.primary,
    this.showFill = true,
  });

  final List<double> values;
  final double width;
  final double height;
  final Color color;
  final bool showFill;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _SparklinePainter(
        values: values,
        color: color,
        showFill: showFill,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.showFill,
  });

  final List<double> values;
  final Color color;
  final bool showFill;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = (max - min) == 0 ? 1.0 : max - min;
    final dx = size.width / (values.length - 1);

    final line = Path();
    for (var i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] - min) / range) * (size.height - 4) - 2;
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }

    if (showFill) {
      final fill = Path.from(line)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// Compact price row used on dashboards and price lists.
class PriceListTile extends StatelessWidget {
  const PriceListTile({
    super.key,
    required this.commodity,
    required this.market,
    required this.region,
    required this.retail,
    required this.unit,
    required this.changePercent,
    this.trend = const [],
    this.onTap,
    this.sourceLabel,
    this.showDivider = true,
  });

  final String commodity;
  final String market;
  final String region;
  final double retail;
  final String unit;
  final double changePercent;
  final List<double> trend;
  final VoidCallback? onTap;
  final String? sourceLabel;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(commodity, style: AppText.h3),
                      const SizedBox(height: 1),
                      Text(
                        '$market · $region',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.small,
                      ),
                    ],
                  ),
                ),
                if (trend.length > 1) ...[
                  Sparkline(values: trend, width: 52, height: 26),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatTsh(retail),
                      style: AppText.h3.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 14.5,
                      ),
                    ),
                    Text('kwa $unit', style: AppText.small),
                    const SizedBox(height: 3),
                    ChangeBadge(percent: changePercent, compact: true),
                  ],
                ),
              ],
            ),
            if (sourceLabel != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const SizedBox(width: 54),
                  Icon(
                    Icons.verified_outlined,
                    size: 12,
                    color: sourceLabel == 'Imethibitishwa'
                        ? AppColors.success
                        : AppColors.muted,
                  ),
                  const SizedBox(width: 3),
                  Text(sourceLabel!, style: AppText.small),
                ],
              ),
            ],
            if (showDivider) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(),
            ],
          ],
        ),
      ),
    );
  }
}
