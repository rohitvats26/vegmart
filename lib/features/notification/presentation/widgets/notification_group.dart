import 'package:flutter/material.dart';
import 'package:vegmart/features/notification/data/models/app_notification.dart';
import 'package:vegmart/features/notification/presentation/widgets/notification_title.dart';

class NotificationGroup extends StatelessWidget {
  final String title;
  final List<AppNotification> notifications;
  final bool isSelectionMode;
  final Set<int> selectedIds;
  final VoidCallback? onMarkAllRead;
  final Function(int)? onTapNotification;
  final VoidCallback? onLongPressNotification;
  final Function(int)? onSelectNotification;

  const NotificationGroup({
    required this.title,
    required this.notifications,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.onMarkAllRead,
    this.onTapNotification,
    this.onLongPressNotification,
    this.onSelectNotification,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (onMarkAllRead != null && title == 'Yesterday')
                TextButton(
                  onPressed: onMarkAllRead,
                  child: Text(
                    'Mark all as read',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Color(0xFF0DB561),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ...notifications.map((notification) => NotificationTile(
          notification: notification,
          isSelected: selectedIds.contains(notification.id),
          isSelectionMode: isSelectionMode,
          onTap: () => onTapNotification?.call(notification.id),
          onLongPress: onLongPressNotification,
          onSelect: () => onSelectNotification?.call(notification.id),
        )),
      ],
    );
  }
}