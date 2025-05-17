import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vegmart/core/widgets/add_to_cart_popup.dart';
import 'package:vegmart/core/widgets/discount_banner.dart';
import 'package:vegmart/data/models/product_option.dart';

class ProductAddPopup {
  static void show(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ProductPopupContent(screenHeight: screenHeight, isMobile: isMobile);
      },
    );
  }
}

class _ProductPopupContent extends StatefulWidget {
  final double screenHeight;
  final bool isMobile;

  const _ProductPopupContent({required this.screenHeight, required this.isMobile});

  @override
  __ProductPopupContentState createState() => __ProductPopupContentState();
}

class __ProductPopupContentState extends State<_ProductPopupContent> {
  final Map<int, int> _itemCounts = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final List<ProductOption> productOptions = [
      ProductOption(
        imagePath: 'assets/vegetables/Muskmelon.jpeg',
        isBestValue: false,
        discount: '10% OFF',
        details: '75 g',
        combo: '3',
        unitPrice: '₹24/100 g',
        currentPrice: '₹54',
        originalPrice: '₹60',
      ),
      ProductOption(
        imagePath: 'assets/vegetables/Muskmelon.jpeg',
        isBestValue: false,
        details: '75 g',
        combo: '1',
        unitPrice: '₹28.7/100 g',
        currentPrice: '₹20',
        originalPrice: '₹34',
      ),
    ];

    for (int i = 0; i < productOptions.length; i++) {
      _itemCounts.putIfAbsent(i, () => 0);
    }

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      constraints: BoxConstraints(maxHeight: widget.isMobile ? widget.screenHeight * 0.7 : widget.screenHeight * 0.6),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: isDarkMode ? Colors.grey[600] : const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
            // Header with product name
            Padding(
              padding: EdgeInsets.fromLTRB(16, widget.isMobile ? 12 : 16, 16, widget.isMobile ? 12 : 16),
              child: Text(
                'Kurkure Namkeen Masala Munch',
                style: TextStyle(
                  fontSize: widget.isMobile ? 18 : 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF212121),
                ),
              ),
            ),

            // Product cards list
            ...productOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;

              if (option.isBestValue) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: widget.isMobile ? 16 : 24),
                    padding: const EdgeInsets.fromLTRB(5, 18, 5, 5),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : const Color(0xFFFFEEE6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // BEST VALUE badge
                        Positioned(
                          top: -21,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDarkMode ? theme.primaryColorDark : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('BEST VALUE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFFD85511))),
                            ),
                          ),
                        ),
                        // Product card
                        _buildProductCardContent(index, option, widget.isMobile, theme),
                      ],
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 19 : 30, vertical: 5),
                  child: _buildProductCardContent(index, option, widget.isMobile, theme),
                );
              }
            }).toList(),

            // Add button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Item Total : ₹${_calculateTotal(productOptions)}",
                            style: TextStyle(fontSize: widget.isMobile ? 16 : 17, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Confirm",
                              style: TextStyle(fontSize: widget.isMobile ? 16 : 17, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                          onTap: () => {Navigator.pop(context), AddToCartPopup.show(context)},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCardContent(int index, ProductOption option, bool isMobile, ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              option.isBestValue
                  ? Colors.transparent
                  : isDarkMode
                  ? Colors.grey[700]!
                  : const Color(0xFFEEEEEE),
        ),
        boxShadow:
            isDarkMode
                ? []
                : [
                  BoxShadow(color: const Color(0xFFEDECF1).withOpacity(1), blurRadius: 20, offset: const Offset(0, 6), spreadRadius: 0),
                  BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 0, offset: const Offset(0, -2), spreadRadius: 0),
                ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Container(
                      width: isMobile ? 70 : 80,
                      height: isMobile ? 70 : 80,
                      decoration: BoxDecoration(color: isDarkMode ? Colors.grey[800] : const Color(0xFFF5F5F5)),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          option.imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          color: isDarkMode ? Colors.white.withOpacity(0.9) : null,
                          colorBlendMode: isDarkMode ? BlendMode.modulate : null,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: isDarkMode ? Colors.grey[800] : const Color(0xFFF5F5F5),
                                child: Icon(Icons.fastfood, color: isDarkMode ? Colors.grey[500] : const Color(0xFF9E9E9E), size: 30),
                              ),
                        ),
                      ),
                    ),

                    SizedBox(width: isMobile ? 18 : 22),
                    // combo details
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            option.details,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          if (option.combo != null && option.combo != '1')
                            Text(
                              "x ${option.combo!}",
                              style: TextStyle(fontSize: isMobile ? 12 : 13, color: isDarkMode ? Colors.grey[400] : const Color(0xFF757575)),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: isMobile ? 25 : 30),
                    Container(
                      width: 2,
                      height: 55,
                      color: isDarkMode ? Colors.grey[700]! : const Color(0xFFEEEEEE).withOpacity(0.8),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    // Product details
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Unit price
                                Text(
                                  option.unitPrice,
                                  style: TextStyle(
                                    fontSize: isMobile ? 11 : 12,
                                    color: isDarkMode ? Colors.grey[400] : const Color(0xFF616161),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isMobile ? 4 : 8),
                            // Prices
                            Row(
                              children: [
                                Text(
                                  option.currentPrice,
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDarkMode ? Colors.white : const Color(0xFF212121),
                                  ),
                                ),
                                if (option.originalPrice != null) ...[
                                  SizedBox(width: isMobile ? 4 : 8),
                                  Text(
                                    option.originalPrice!,
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 13,
                                      decoration: TextDecoration.lineThrough,
                                      color: isDarkMode ? Colors.grey[500] : const Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right column (counter or add button)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [if (_itemCounts[index]! > 0) _buildCounter(index, isMobile, theme) else _buildAddButton(index, isMobile, theme)],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (option.discount != null)
            DiscountBanner(
              discount: option.discount,
              bannerTopOffset: 5,
              bannerLeftOffset: -6.0,
              kHeight: 35,
              kWidth: 60,
              bannerTextLeftOffset: -6.0,
              bannerTextTopOffset: -1.0,
              kTextSizeLarge: 7,
              kTextSizeSmall: 6,
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(int index, bool isMobile, ThemeData theme) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(child: Text("ADD", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: theme.primaryColor))),
      ),
      onTap: () {
        setState(() {
          _itemCounts[index] = 1;
        });
      },
    );
  }

  Widget _buildCounter(int index, bool isMobile, ThemeData theme) {
    final count = _itemCounts[index] ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSvgButton(
            height: 15.0,
            width: 15.0,
            svgAsset: 'assets/icons/minus.svg',
            color: theme.primaryColor,
            onTap: count > 0 ? () => setState(() => _itemCounts[index] = count - 1) : null,
          ),
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                _itemCounts[index].toString(),
                style: TextStyle(fontSize: 16, fontFamily: 'SFProText', fontWeight: FontWeight.w900, color: theme.primaryColor),
              ),
            ),
          ),
          _buildSvgButton(
            height: 16,
            width: 16,
            svgAsset: 'assets/icons/plus.svg',
            color: theme.primaryColor,
            onTap: () => setState(() => _itemCounts[index] = count + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSvgButton({required double height, required double width, required String svgAsset, Color? color, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(child: Center(child: SvgPicture.asset(svgAsset, width: width, height: height, color: color))),
      ),
    );
  }

  double _calculateTotal(List<ProductOption> options) {
    double total = 0;
    for (int i = 0; i < options.length; i++) {
      final count = _itemCounts[i] ?? 0;
      if (count > 0) {
        final priceStr = options[i].currentPrice.replaceAll('₹', '');
        final price = double.tryParse(priceStr) ?? 0;
        total += price * count;
      }
    }
    return total;
  }
}
