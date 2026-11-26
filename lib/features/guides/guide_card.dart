import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/guide.dart';
import 'guide_detail_screen.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({super.key, required this.guide, this.compact = false});

  final FarmingGuide guide;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadow: AppShadows.soft,
      onTap: () => pushScreen(context, GuideDetailScreen(guide: guide)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: compact ? 76 : 88,
              height: compact ? 76 : 88,
              child: MkImage(asset: guide.imageAsset),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h3,
                ),
                const SizedBox(height: 3),
                Text(
                  guide.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.small,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 3),
                        Text('Dakika ${guide.minutes}', style: AppText.small),
                      ],
                    ),
                    MkPill(
                      label: guide.level,
                      foreground: AppColors.info,
                      background: AppColors.infoSoft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                    ),
                    if (guide.offlineReady) const OfflineChip(),
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
