import 'package:flutter/material.dart';
import 'package:vegmart/core/theme/app_colors.dart';
import 'package:vegmart/core/widgets/discount_banner.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String currentPrice;
  final String originalPrice;
  final String quantity;
  final String discount;
  final String? tag;
  final double? imageHeight;
  final VoidCallback onAddPressed;
  final VoidCallback onProductTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.currentPrice,
    required this.originalPrice,
    required this.quantity,
    required this.discount,
    this.tag,
    this.imageHeight = 170.0,
    required this.onAddPressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: onProductTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay banner and Most Bought tag
            Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    imagePath,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    color: isDark ? Colors.white.withOpacity(0.9) : null,
                    colorBlendMode: isDark ? BlendMode.modulate : null,
                  ),
                ),

                DiscountBanner(discount: discount),
                if (tag != null)
                  // Most Bought tag (bottom-left)
                  Positioned(
                    bottom: 8,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.teal[800] : const Color(0xFFEBFDF0),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: isDark ? Colors.teal[800]!.withOpacity(0.3) : const Color(0xFFEBFDF0).withOpacity(0.3)),
                      ),
                      child: Text(
                        tag!,
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF326242), fontSize: 8, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product title
                  SizedBox(
                    height: 50, // Adjust this value as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: isDark ? Colors.white : const Color(0xFF000008),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(quantity, style: TextStyle(color: isDark ? Colors.grey[400] : const Color(0xFF180400), fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price row
                  Row(
                    children: [
                      Text(
                        '₹$currentPrice',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '₹$originalPrice',
                        style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600], decoration: TextDecoration.lineThrough, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Add to Cart button
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      onPressed: onAddPressed,
                      style: TextButton.styleFrom(
                        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                        foregroundColor: theme.primaryColor,
                        minimumSize: const Size(double.infinity, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: theme.primaryColor.withOpacity(isDark ? 0.5 : 0.30), width: 2),
                        ),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : theme.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
