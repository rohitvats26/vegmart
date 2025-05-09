class ProductOption {
  final String imagePath;
  final bool isBestValue;
  final String? discount;
  final String details;
  final String? combo;
  final String unitPrice;
  final String currentPrice;
  final String? originalPrice;
  final String? shopForPrice;

  ProductOption({
    required this.imagePath,
    required this.isBestValue,
    this.discount,
    required this.details,
    this.combo,
    required this.unitPrice,
    required this.currentPrice,
    this.originalPrice,
    this.shopForPrice,
  });
}