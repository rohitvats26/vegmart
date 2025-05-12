import 'package:flutter/material.dart';
import 'package:vegmart/core/widgets/discount_banner.dart';
import 'package:vegmart/core/widgets/product_add_popup.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final List<String> imageAssets = [
    'assets/vegetables/Muskmelon.jpeg',
    'assets/vegetables/carrots.jpg',
    'assets/vegetables/Muskmelon.jpeg',
  ];
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : const Color(0xFFEDECF1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDarkMode ? Colors.white : null),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: isDarkMode ? Colors.white : null),
            onPressed: () {},
          ),
        ],
        title: Text(
          'Indian Tomato (Tamatar)',
          style: TextStyle(
            fontSize: 17,
            color: isDarkMode ? Colors.white : null,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[800]! : Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isDarkMode ? theme.cardColor : Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 480,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView.builder(
                            itemCount: imageAssets.length,
                            controller: PageController(viewportFraction: 1.0),
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (_, index) => AnimatedBuilder(
                              animation: PageController(viewportFraction: 1.0),
                              builder: (context, child) {
                                double value = 1.0;
                                if (index == _currentImageIndex) {
                                  value = Curves.easeOut.transform(
                                    (1 - (_currentImageIndex - index).abs().toDouble()));
                                  }

                                    return Transform.scale(
                                    scale: value,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 20,
                                        bottom: 40 - (1 - value) * 20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Hero(
                                          tag: 'product-hero-$index',
                                          child: Image.asset(
                                            imageAssets[index],
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: isDarkMode
                                                  ? Colors.grey[800]
                                                  : const Color(0xFFF8F8F8),
                                              child: Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  size: 60,
                                                  color: isDarkMode
                                                      ? Colors.grey[600]
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                imageAssets.length,
                                    (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _currentImageIndex == index ? 11 : 8,
                                  height: _currentImageIndex == index ? 11 : 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? theme.primaryColor
                                        : Colors.grey.withOpacity(0.6),
                                    boxShadow: isDarkMode
                                        ? null
                                        : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          DiscountBanner(
                            discount: '22% OFF',
                            bannerTopOffset: 12,
                            bannerLeftOffset: -16.5,
                            kHeight: 60,
                            kWidth: 120,
                            kTextSizeLarge: 11,
                            kTextSizeSmall: 10,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Indian Tomato (Tamatar)',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        height: 1.3,
                                        letterSpacing: -0.3,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '350 g',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : const Color(0xFF888888),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '\₹14',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          const TextSpan(text: '  '),
                                          TextSpan(
                                            text: '\₹18',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDarkMode
                                                  ? Colors.grey[500]
                                                  : const Color(0xFFAAAAAA),
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isDarkMode
                                        ? null
                                        : [
                                      BoxShadow(
                                        color: const Color(0xFFEDECF1).withOpacity(1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.4),
                                        blurRadius: 0,
                                        offset: const Offset(0, -2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isDarkMode
                                        ? theme.cardColor
                                        : Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => ProductAddPopup.show(context),
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isDarkMode
                                                ? Colors.grey[700]!
                                                : const Color(0xFFD8D8D8),
                                            width: 1.5,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '2 options',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 18,
                                              color: theme.primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Divider(
                            height: 1.5,
                            color: isDarkMode
                                ? Colors.grey[700]!
                                : const Color(0xFFD8D8D8),
                          ),
                          const SizedBox(height: 14),

                          Text(
                            'Description',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Fresh, juicy Indian tomatoes perfect for curries, salads, and sauces. '
                                'Grown organically with no artificial preservatives. Rich in lycopene and vitamin C. '
                                'Each tomato is hand-picked at peak ripeness for optimal flavor.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : null,
                            ),
                          ),
                        ],
                      ),
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
}