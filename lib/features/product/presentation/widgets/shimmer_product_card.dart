import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vegmart/core/theme/app_colors.dart';

class ShimmerProductCard extends StatelessWidget {
  final AppColors colors;
  final bool isTablet;

  const ShimmerProductCard({required this.colors, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Image
            Container(
              width: isTablet ? 120 : 100,
              height: isTablet ? 120 : 100,
              decoration: BoxDecoration(color: colors.shimmerBase, borderRadius: BorderRadius.circular(16)),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer Discount
                  Container(
                    width: isTablet ? 70 : 60,
                    height: isTablet ? 28 : 24,
                    decoration: BoxDecoration(color: colors.shimmerBase, borderRadius: BorderRadius.circular(6)),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  // Shimmer Title
                  Container(
                    width: double.infinity,
                    height: isTablet ? 24 : 20,
                    decoration: BoxDecoration(color: colors.shimmerBase, borderRadius: BorderRadius.circular(4)),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  // Shimmer Subtitle
                  Container(
                    width: isTablet ? 100 : 80,
                    height: isTablet ? 20 : 16,
                    decoration: BoxDecoration(color: colors.shimmerBase, borderRadius: BorderRadius.circular(4)),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  // Shimmer Price
                  Container(
                    width: isTablet ? 80 : 60,
                    height: isTablet ? 24 : 20,
                    decoration: BoxDecoration(color: colors.shimmerBase, borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().shimmer(delay: 300.ms, duration: 1000.ms, color: colors.shimmerHighlight.withOpacity(0.3));
  }
}