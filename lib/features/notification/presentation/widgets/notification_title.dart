import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vegmart/features/notification/data/models/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSelect;

  const NotificationTile({
    required this.notification,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onTap,
    this.onLongPress,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeText = _getTimeText(notification.timestamp);

    return InkWell(
      onTap: isSelectionMode ? onSelect : onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 4),
                child: Checkbox(
                  activeColor: Color(0xFF0DB561),
                  value: isSelected,
                  onChanged: (_) => onSelect?.call(),
                  shape: const CircleBorder(),
                ),
              ),
            _buildIcon(context),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(context, timeText),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: notification.isRead ? Color(0xFFA8A8A8) : Color(0xFF706E6E),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!notification.isRead) _buildNewBadge(context),
                  if (notification.actions.isNotEmpty)
                    _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        shape: BoxShape.circle,
      ),
      child: Icon(
        notification.icon,
        color: Color(0xFF0DB561),
        size: 20,
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context, String timeText) {
    return Row(
      children: [
        Expanded(
          child: Text(
            notification.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: notification.isRead
                  ? Color(0xFF393939).withOpacity(0.6)
                  : Color(0xFF393939),
            ),
          ),
        ),
        Text(
          timeText,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildNewBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: notification.isUrgent
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            notification.isUrgent ? 'URGENT' : 'NEW',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: notification.actions.map((action) {
          return GestureDetector(
            onTap: () => action.onPressed(notification.id),
            child: Container(
              padding: const EdgeInsets.only(bottom: 1), // For underline spacing
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF0DB561),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    action.icon,
                    size: 16,
                    color: Color(0xFF0DB561),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    action.text,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Color(0xFF0DB561),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getTimeText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date.isAfter(today)) {
      return DateFormat('h:mm a').format(date);
    } else if (date.isAfter(today.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return DateFormat('MMM d').format(date);
  }
}