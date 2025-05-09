import 'package:flutter/material.dart';
import 'package:vegmart/core/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String currentPrice;
  final String originalPrice;
  final String quantity;
  final String discount;
  final String? tag;
  final VoidCallback onAddPressed;

  const ProductCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.currentPrice,
    required this.originalPrice,
    required this.quantity,
    required this.discount,
    this.tag,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlay banner and Most Bought tag
          Stack(
            children: [
              // Product image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.network(imagePath, width: double.infinity, height: 170, fit: BoxFit.cover),
              ),

              // Discount banner overlay (positioned at top)
              Positioned(
                top: -10,
                left: -37,
                child: SizedBox(
                  width: 120,
                  height: 60,
                  child: Stack(
                    children: [
                      ClipRRect(child: Image.asset("assets/badge.png", height: 60, width: double.infinity, fit: BoxFit.fill)),
                      Positioned(
                        top: -10,
                        bottom: 0,
                        left: -10,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              discount.split(' ')[0],
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                            const Text('OFF', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (tag != null)
                // Most Bought tag (bottom-left)
                Positioned(
                  bottom: 8,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0xFFEBFDF0),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFEBFDF0).withOpacity(0.3)),
                    ),
                    child: Text(
                      tag!,
                      style: const TextStyle(color: Color(0xFF326242), fontSize: 8, fontWeight: FontWeight.w600),
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          color: Color(0xFF000008),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        quantity,
                        style: TextStyle(color: Color(0xFF180400), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Price row
                Row(
                  children: [
                    Text('₹$currentPrice', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
                    const SizedBox(width: 6),
                    Text(
                      '₹$originalPrice',
                      style: TextStyle(color: Colors.grey.shade600, decoration: TextDecoration.lineThrough, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Add to Cart button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    onPressed: onAddPressed,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.primaryColor,
                      minimumSize: const Size(double.infinity, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: theme.primaryColor.withOpacity(0.30), width: 2),
                      ),
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
