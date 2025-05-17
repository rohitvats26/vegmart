import 'package:flutter/material.dart';
import 'package:vegmart/core/widgets/discount_banner.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String currentPrice;
  final String originalPrice;
  final String quantity;
  final String discount;
  final String? tag;
  final double? imageHeight;
  final bool useCompactLayout;
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
    required this.useCompactLayout,
    required this.onAddPressed,
    required this.onProductTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int itemCount = 0;

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
        onTap: widget.onProductTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay banner and Most Bought tag
            Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    widget.imagePath,
                    width: double.infinity,
                    height: widget.imageHeight,
                    fit: BoxFit.cover,
                    color: isDark ? Colors.white.withOpacity(0.9) : null,
                    colorBlendMode: isDark ? BlendMode.modulate : null,
                  ),
                ),

                DiscountBanner(discount: widget.discount),
                if (widget.tag != null)
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
                        widget.tag!,
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
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: isDark ? Colors.white : const Color(0xFF000008),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(widget.quantity, style: TextStyle(color: isDark ? Colors.grey[400] : const Color(0xFF180400), fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Conditionally render layout based on useCompactLayout
                  if (widget.useCompactLayout)
                    _buildCompactLayout(theme, isDark)
                  else
                    _buildOriginalLayout(theme, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalLayout(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price row
        Row(
          children: [
            Text(
              '₹${widget.currentPrice}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '₹${widget.originalPrice}',
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Original Add to Cart button or Quantity counter
        if (itemCount == 0)
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: TextButton(
              onPressed: () {
                setState(() {
                  itemCount = 1;
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                foregroundColor: theme.primaryColor,
                minimumSize: const Size(double.infinity, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: theme.primaryColor.withOpacity(isDark ? 0.5 : 0.30),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : theme.primaryColor,
                ),
              ),
            ),
          )
        else
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: 18,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      if (itemCount > 0) {
                        itemCount--;
                      }
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  splashRadius: 20,
                ),
                Text(
                  itemCount.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 18,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      itemCount++;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCompactLayout(ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Price column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${widget.currentPrice}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              '₹${widget.originalPrice}',
              style: TextStyle(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
              ),
            ),
          ],
        ),

        // Compact Add button or Quantity counter
        if (itemCount == 0)
          SizedBox(
            height: 32,
            width: 70,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  itemCount = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          Container(
            height: 32,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Decrement button
                Container(
                  width: 32,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (itemCount > 0) {
                          itemCount--;
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),

                // Quantity
                Text(
                  itemCount.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),

                // Increment button
                Container(
                  width: 32,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        itemCount++;
                      });
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
