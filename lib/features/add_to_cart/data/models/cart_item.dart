class CartItemModel {
  final String title;
  final String quantity;
  final int price;
  final int? originalPrice;
  final int quantityCount;
  final String imageUrl;

  CartItemModel({
    required this.title,
    required this.quantity,
    required this.price,
    this.originalPrice,
    required this.quantityCount,
    required this.imageUrl,
  });

  CartItemModel copyWith({int? quantityCount}) {
    return CartItemModel(
      title: title,
      quantity: quantity,
      price: price,
      originalPrice: originalPrice,
      quantityCount: quantityCount ?? this.quantityCount,
      imageUrl: imageUrl,
    );
  }
}
