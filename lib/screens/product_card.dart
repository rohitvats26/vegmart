import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegmart/screens/product_add_popup.dart';
import 'package:vegmart/screens/product_detail_screen.dart';



class ProductCard extends StatefulWidget {

  final String title;
  final String imagePath;
  final String currentPrice;
  final String originalPrice;
  final String quantity;
  final String discount;
  final String? tag;
  final VoidCallback onAddPressed;

  const ProductCard({super.key,
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
  _ProductCardState createState() => _ProductCardState();

}

class _ProductCardState extends State<ProductCard> {


  void _onProductTap(){
    if (!mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProductDetailScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Get screen size information
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine device type based on screen width
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    // Responsive values
    final cardWidth =
        isMobile
            ? screenWidth *
                0.42 // Take about 42% of screen width on mobile (2 cards per row)
            : isTablet
            ? screenWidth *
                0.3 // Take 30% on tablet (3 cards per row)
            : screenWidth * 0.2; // Take 20% on desktop (5 cards per row)

    final imageHeight =
        isMobile
            ? screenHeight * 0.12
            : isTablet
            ? screenHeight * 0.14
            : screenHeight * 0.16;

    final titleFontSize =
        isMobile
            ? 14.0
            : isTablet
            ? 15.0
            : 16.0;
    final priceFontSize =
        isMobile
            ? 14.0
            : isTablet
            ? 16.0
            : 18.0;
    final addButtonSize =
        isMobile
            ? 24.0
            : isTablet
            ? 26.0
            : 28.0;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _onProductTap();
            // Handle product tap
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount Badge (left side)
                  if (widget.discount.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          widget.discount,
                          style: TextStyle(color: Colors.white, fontSize: isMobile ? 10 : 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  // Product Image - Full width with responsive height
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      image: DecorationImage(image: AssetImage(widget.imagePath), fit: BoxFit.contain),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 8 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title with responsive font size
                        Text(
                          widget.title,
                          style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w700, height: 1.2),
                          maxLines: isMobile ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isMobile ? 4 : 6),

                        // Optional tag line
                        if (widget.tag != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: isMobile ? 4 : 6),
                            child: Text(
                              widget.tag!,
                              style: TextStyle(
                                fontSize: isMobile ? 10 : 11,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                        // Quantity with responsive font size
                        Text(widget.quantity, style: TextStyle(fontSize: isMobile ? 10 : 11, color: Colors.grey.shade500)),
                        SizedBox(height: isMobile ? 2 : 4),

                        // Price and Add Button Row with better alignment
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Prices in a column to handle potential overflow
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '\₹${widget.currentPrice}',
                                        style: TextStyle(
                                          fontSize: priceFontSize,
                                          fontWeight: FontWeight.w800,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: isMobile ? 4 : 6),
                                      Text(
                                        '\₹${widget.originalPrice}',
                                        style: TextStyle(
                                          fontSize: priceFontSize - 2,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Responsive circular Add Button
                            Container(
                              width: addButtonSize,
                              height: addButtonSize,
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add, color: Colors.white, size: addButtonSize - 6),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  ProductAddPopup.show(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
