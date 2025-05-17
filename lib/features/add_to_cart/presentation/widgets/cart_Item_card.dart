import 'package:flutter/material.dart';
import 'package:vegmart/features/add_to_cart/data/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final Function(int) onQuantityChanged;

  const CartItemWidget({super.key, required this.item, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

    // Responsive sizing calculations
    final bool isSmallMobile = screenSize.width <= 395;
    final bool isMobile = screenSize.width > 395 && screenSize.width <= 500;
    final bool isLargeMobile = screenSize.width > 500 && screenSize.width <= 600;
    final bool isTablet = screenSize.width > 600 && screenSize.width < 1024;

    // Calculate dimensions based on screen size
    final double imageSize =
        isSmallMobile
            ? 40
            : isMobile
            ? 45
            : isLargeMobile
            ? 50
            : isTablet
            ? 55
            : 60;

    final double fontSizeSmall =
        isSmallMobile
            ? 10
            : isMobile
            ? 12
            : isLargeMobile
            ? 13
            : isTablet
            ? 14
            : 15;

    final double fontSizeMedium =
        isSmallMobile
            ? 12
            : isMobile
            ? 14
            : isLargeMobile
            ? 15
            : isTablet
            ? 16
            : 17;

    final double quantityControlWidth =
        isSmallMobile
            ? 80
            : isMobile
            ? 90
            : isLargeMobile
            ? 100
            : isTablet
            ? 110
            : 120;

    final double horizontalPadding =
        isSmallMobile
            ? 8
            : isMobile
            ? 10
            : isLargeMobile
            ? 16
            : isTablet
            ? 20
            : 24;

    final double verticalPadding =
        isSmallMobile
            ? 8
            : isMobile
            ? 10
            : isLargeMobile
            ? 12
            : isTablet
            ? 14
            : 16;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            child:
                item.imageUrl.isNotEmpty
                    ? Image.asset(item.imageUrl, fit: BoxFit.cover)
                    : Icon(Icons.image, color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
          ),
          SizedBox(width: isSmallMobile ? 10 : 12),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: fontSizeSmall,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.grey.shade100 : const Color(0xFF3A3B3D),
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  item.quantity,
                  style: TextStyle(
                    fontSize: fontSizeSmall - 1,
                    color: isDarkMode ? Colors.grey.shade400 : const Color(0xFF8C8C8C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          SizedBox(
            width: quantityControlWidth,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: isSmallMobile || isMobile ? 14 : 16, color: theme.primaryColor),
                    onPressed: () => onQuantityChanged(-1),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: isTablet ? 38 : 28, minHeight: isTablet ? 37 : 28),
                  ),
                  Text('${item.quantityCount}', style: TextStyle(fontSize: fontSizeMedium - 2, color: theme.primaryColor)),
                  IconButton(
                    icon: Icon(Icons.add, size: isSmallMobile || isMobile ? 14 : 16, color: theme.primaryColor),
                    onPressed: () => onQuantityChanged(1),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: isTablet ? 38 : 28, minHeight: isTablet ? 37 : 28),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width:
                isSmallMobile
                    ? 10
                    : isMobile
                    ? 10
                    : isLargeMobile
                    ? 12
                    : 35,
          ),

          // Price Information
          SizedBox(
            width: isSmallMobile ? 36 : 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item.originalPrice != null)
                  Text(
                    '₹${item.originalPrice}',
                    style: TextStyle(
                      fontSize: fontSizeSmall - 1,
                      color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  '₹${item.price}',
                  style: TextStyle(
                    fontSize: fontSizeMedium - 1,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.grey.shade100 : const Color(0xFF3A3B3D),
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
