import 'package:flutter/cupertino.dart';
import 'package:vegmart/features/notification/data/models/notification_action.dart';

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

enum NotificationCategory {
  order,
  promotion,
  feedback,
  account,
  security,
}