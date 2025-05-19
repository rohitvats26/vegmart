import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order {
  final String id;
  final DateTime date;
  final String status;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);

  Color get statusColor {
    switch (status) {
      case 'Delivered':
        return Colors.green[600]!;
      case 'Processing':
        return Colors.orange[600]!;
      case 'Shipped':
        return Colors.blue[600]!;
      case 'Cancelled':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'Delivered':
        return Icons.check_circle;
      case 'Processing':
        return Icons.hourglass_top;
      case 'Shipped':
        return Icons.local_shipping;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}