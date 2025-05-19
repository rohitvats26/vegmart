class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
  final String? variant;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    this.variant,
  });
}