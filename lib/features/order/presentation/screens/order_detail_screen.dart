import 'package:flutter/material.dart';
import 'package:vegmart/features/order/data/models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.id}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Hero(
          tag: 'order-${order.id}',
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(order.statusIcon, color: order.statusColor, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        order.id,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Status: ${order.status}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Date: ${order.formattedDate}', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Total: \$${order.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Divider(color: Theme.of(context).dividerColor),
                  const SizedBox(height: 16),
                  Text('Items', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Sample Item 1 - \$29.99', style: Theme.of(context).textTheme.bodyMedium),
                  Text('Sample Item 2 - \$30.00', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}