import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 1,
      title: 'Order Shipped',
      message: 'Your order #12345 has been shipped and will arrive soon. Track your package for real-time updates.',
      icon: Icons.local_shipping,
      category: NotificationCategory.order,
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      actions: [
        NotificationAction(
          text: 'Track Order',
          icon: Icons.track_changes,
          onPressed: (id) => print('Track order $id'),
        ),
      ],
    ),
    AppNotification(
      id: 2,
      title: 'Flash Sale - Limited Time!',
      message: '50% off on all electronics for the next 24 hours! Don\'t miss this exclusive offer.',
      icon: Icons.flash_on_outlined,
      category: NotificationCategory.promotion,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isUrgent: true,
    ),
    AppNotification(
      id: 3,
      title: 'Product Review Request',
      message: 'Please rate your recent purchase of "Wireless Headphones". Your feedback helps us improve.',
      icon: Icons.star_rate_outlined,
      category: NotificationCategory.feedback,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      actions: [
        NotificationAction(
          text: 'Leave Review',
          icon: Icons.rate_review_outlined,
          onPressed: (id) => print('Review for $id'),
        ),
      ],
    ),
    AppNotification(
      id: 4,
      title: 'Order Delivered',
      message: 'Your order #12346 has been successfully delivered. We hope you enjoy your purchase!',
      icon: Icons.check_circle_outlined,
      category: NotificationCategory.order,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: 5,
      title: 'New Payment Method Added',
      message: 'Your PayPal account has been successfully linked to your profile.',
      icon: Icons.payment_outlined,
      category: NotificationCategory.account,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AppNotification(
      id: 6,
      title: 'Security Alert',
      message: 'New login detected from a new device. If this wasn\'t you, please secure your account.',
      icon: Icons.security_outlined,
      category: NotificationCategory.security,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isUrgent: true,
      actions: [
        NotificationAction(
          text: 'Secure Account',
          icon: Icons.lock,
          onPressed: (id) => print('Secure account $id'),
        ),
      ],
    ),
  ];

  bool _isSelectionMode = false;
  final Set<int> _selectedNotifications = <int>{};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) _selectedNotifications.clear();
    });
  }

  void _toggleNotificationSelection(int id) {
    setState(() {
      if (_selectedNotifications.contains(id)) {
        _selectedNotifications.remove(id);
      } else {
        _selectedNotifications.add(id);
      }
    });
  }

  void _markSelectedAsRead() {
    setState(() {
      for (var id in _selectedNotifications) {
        _notifications.firstWhere((n) => n.id == id).isRead = true;
      }
      _selectedNotifications.clear();
      _isSelectionMode = false;
    });
    _showSnackBar('Marked ${_selectedNotifications.length} as read');
  }

  void _deleteSelected() {
    setState(() {
      _notifications.removeWhere((n) => _selectedNotifications.contains(n.id));
      _selectedNotifications.clear();
      _isSelectionMode = false;
    });
    _showSnackBar('Deleted ${_selectedNotifications.length} notifications');
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    _showSnackBar('All notifications marked as read');
  }

  void _markAsRead(int id) {
    setState(() {
      _notifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _getTimeGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) return 'Today';
    if (date.isAfter(yesterday)) return 'Yesterday';
    return 'Earlier';
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotifications();
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: _buildAppBar(context, unreadCount),
      body: _buildNotificationList(groupedNotifications),
    );
  }

  AppBar _buildAppBar(BuildContext context, int unreadCount) {
    return AppBar(
      leading: _isSelectionMode
          ? IconButton(
        icon: const Icon(Icons.close),
        onPressed: _toggleSelectionMode,
      )
          : IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: _isSelectionMode
          ? Text('${_selectedNotifications.length} selected')
          : Padding(padding: EdgeInsets.only(bottom: 4),
      child: const Text('Notifications')),
      actions: _buildAppBarActions(unreadCount),
    );
  }

  List<Widget> _buildAppBarActions(int unreadCount) {
    if (_isSelectionMode) {
      return [
        IconButton(
          icon: const Icon(Icons.done_all),
          onPressed: _markSelectedAsRead,
          tooltip: 'Mark as read',
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteSelected,
          tooltip: 'Delete',
        ),
      ];
    } else {
      
      return [
        if (unreadCount > 0)
        TextButton(
            onPressed: _markAllAsRead,
            child: const Text('MARK ALL READ', style: TextStyle(color: Color(0xFF0DB561))),
          ),
        IconButton(
          icon: const Icon(Icons.select_all, color: Color(0xFF0DB561)),
          onPressed: _toggleSelectionMode,
          tooltip: 'Select multiple',
        ),
      ];
    }
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> groupedNotifications) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: groupedNotifications.length,
      separatorBuilder: (_, index) => const Divider(height: 8),
      itemBuilder: (_, index) {
        final group = groupedNotifications[index];
        return _NotificationGroup(
          title: group['title'] as String,
          notifications: group['items'] as List<AppNotification>,
          isSelectionMode: _isSelectionMode,
          selectedIds: _selectedNotifications,
          onMarkAllRead: index == 1 ? _markAllAsRead : null,
          onTapNotification: _markAsRead,
          onLongPressNotification: _toggleSelectionMode,
          onSelectNotification: _toggleNotificationSelection,
        );
      },
    );
  }

  List<Map<String, dynamic>> _groupNotifications() {
    final groups = <String, List<AppNotification>>{};
    for (var notification in _notifications) {
      final group = _getTimeGroup(notification.timestamp);
      groups.putIfAbsent(group, () => []).add(notification);
    }

    return [
      {'title': 'Today', 'items': groups['Today'] ?? []},
      {'title': 'Yesterday', 'items': groups['Yesterday'] ?? []},
      {'title': 'Earlier', 'items': groups['Earlier'] ?? []},
    ];
  }
}

enum NotificationCategory {
  order,
  promotion,
  feedback,
  account,
  security,
}

class AppNotification {
  final int id;
  final String title;
  final String message;
  final IconData icon;
  final NotificationCategory category;
  final DateTime timestamp;
  final List<NotificationAction> actions;
  bool isRead;
  final bool isUrgent;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.category,
    required this.timestamp,
    this.actions = const [],
    this.isRead = false,
    this.isUrgent = false,
  });
}

class NotificationAction {
  final String text;
  final IconData icon;
  final Function(int) onPressed;

  NotificationAction({
    required this.text,
    required this.icon,
    required this.onPressed,
  });
}

class _NotificationGroup extends StatelessWidget {
  final String title;
  final List<AppNotification> notifications;
  final bool isSelectionMode;
  final Set<int> selectedIds;
  final VoidCallback? onMarkAllRead;
  final Function(int)? onTapNotification;
  final VoidCallback? onLongPressNotification;
  final Function(int)? onSelectNotification;

  const _NotificationGroup({
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
        ...notifications.map((notification) => _NotificationTile(
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

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSelect;

  const _NotificationTile({
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