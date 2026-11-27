import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/user.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static IconData _icon(String type) => switch (type) {
        'bei' => Icons.show_chart_rounded,
        'ombi' => Icons.shopping_bag_outlined,
        'hali_ya_hewa' => Icons.wb_cloudy_rounded,
        'jamii' => Icons.forum_outlined,
        _ => Icons.notifications_none_rounded,
      };

  static Color _color(String type) => switch (type) {
        'bei' => AppColors.success,
        'ombi' => AppColors.accent,
        'hali_ya_hewa' => AppColors.info,
        'jamii' => AppColors.primary,
        _ => AppColors.muted,
      };

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final notifications = state.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arifa'),
        actions: [
          if (state.unreadNotifications > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: TextButton.icon(
                icon: const Icon(Icons.done_all_rounded, size: 18),
                label: const Text('Soma zote'),
                onPressed: state.markAllNotificationsRead,
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.notifications_off_outlined,
                    size: 44,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Hakuna arifa', style: AppText.h3),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.sm,
                AppSpacing.page,
                AppSpacing.xxxl,
              ),
              itemCount: notifications.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.dangerSoft,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.danger,
                    ),
                  ),
                  onDismissed: (_) {
                    state.markNotificationRead(item.id);
                  },
                  child: _NotificationTile(
                    notification: item,
                    color: _color(item.type),
                    icon: _icon(item.type),
                    onTap: () => state.markNotificationRead(item.id),
                  ),
                );
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final AppNotification notification;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      onTap: onTap,
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      color: notification.read ? AppColors.surface : AppColors.primarySoft,
      borderColor: notification.read ? null : const Color(0xFFD8EBC8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppText.bodyStrong.copyWith(
                          color: notification.read
                              ? AppColors.inkSoft
                              : AppColors.ink,
                        ),
                      ),
                    ),
                    if (!notification.read)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(notification.body, style: AppText.small),
                const SizedBox(height: 5),
                Text(notification.timeAgo, style: AppText.overline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
