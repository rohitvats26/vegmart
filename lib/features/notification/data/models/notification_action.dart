import 'package:flutter/cupertino.dart';

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