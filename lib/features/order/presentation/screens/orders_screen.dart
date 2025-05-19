import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final List<OrderItem> orders = [
    OrderItem(
      imagePath: 'assets/order_again_icon.png',
      status: OrderStatus.delivered,
      dateTime: '18th Apr 2025, 22:44 pm',
      price: '₹131',
    ),
    OrderItem(
      imagePath: 'assets/order_again_icon.png',
      status: OrderStatus.cancelled,
      dateTime: '18th Apr 2025, 22:42 pm',
      price: '₹131',
    ),
    OrderItem(
      imagePath: 'assets/order_again_icon.png',
      status: OrderStatus.cancelled,
      dateTime: '18th Apr 2025, 22:38 pm',
      price: '₹131',
    ),
    OrderItem(
      imagePath: 'assets/order_again_icon.png',
      status: OrderStatus.delivered,
      dateTime: '3rd Apr 2025, 10:37 am',
      price: '₹764',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: Colors.black87),
        title: Text(
          'Orders',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: orders.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: OrderCard(item: orders[i]),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Add items worth ₹99 to unlock free delivery with ',
                style: TextStyle(fontSize: 13),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'pass',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OrderStatus { delivered, cancelled }

class OrderItem {
  final String imagePath;
  final OrderStatus status;
  final String dateTime;
  final String price;

  OrderItem({
    required this.imagePath,
    required this.status,
    required this.dateTime,
    required this.price,
  });
}

class OrderCard extends StatelessWidget {
  final OrderItem item;

  const OrderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool ok = item.status == OrderStatus.delivered;
    final statusText = ok ? 'Order delivered' : 'Order cancelled';
    final statusColor = ok ? Colors.black87 : Colors.black87;
    final icon = ok ? Icons.check_circle : Icons.cancel;
    final iconColor = ok ? Colors.green : Colors.grey;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // Navigate to order details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: image + status/date + price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      item.imagePath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),

                  // Status & timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(icon, size: 16, color: iconColor),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Placed at ${item.dateTime}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price
                  Text(
                    item.price,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // "Order Again" button text
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: TextButton(
                  onPressed: () {
                    // reorder logic
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Order Again',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
