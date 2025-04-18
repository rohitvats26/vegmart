import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vegmart/screens/product_add_popup.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final List<String> imageAssets = [
    'assets/vegetables/carrots.jpg',
    'assets/vegetables/carrots.jpg',
    'assets/vegetables/carrots.jpg',
  ];
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF1),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        actions: [IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {})],
        title: const Text('Indian Tomato (Tamatar)', style: TextStyle(fontSize: 17)),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //white board container
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero Image Sliver
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 480, // Slightly increased height for better visual impact
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Main Image Carousel
                          PageView.builder(
                            itemCount: imageAssets.length,
                            controller: PageController(viewportFraction: 1.0),

                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder:
                                (_, index) => AnimatedBuilder(
                                  animation: PageController(viewportFraction: 1.0),
                                  builder: (context, child) {
                                    double value = 1.0;
                                    if (index == _currentImageIndex) {
                                      value = Curves.easeOut.transform((1 - (_currentImageIndex - index).abs()) as double);
                                    }

                                    return Transform.scale(
                                      scale: value,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 20,
                                          bottom: 40 - (1 - value) * 20, // Adds subtle vertical margin effect
                                        ),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Hero(
                                            tag: 'product-hero-$index',
                                            child: Image.asset(
                                              imageAssets[index],
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              errorBuilder:
                                                  (_, __, ___) => Container(
                                                    color: const Color(0xFFF8F8F8),
                                                    child: const Center(
                                                      child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
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

                          // Dot Indicators with improved design
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
                                    color: _currentImageIndex == index ? Colors.orange : Colors.grey.withOpacity(0.6),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Discount Badge
                          Positioned(
                            top: 23,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                '22% OFF',
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Title and Origin
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
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
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Price and Options
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Price Column
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '350 g',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xFF888888),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(text: '\₹14', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                                          TextSpan(text: '  '),
                                          TextSpan(
                                            text: '\₹18',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFAAAAAA),
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Options Button
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
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
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => ProductAddPopup.show(context),
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFFD8D8D8), width: 1.5),
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
                                                color: const Color(0xFF41A27F),
                                              ),
                                            ),
                                            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: const Color(0xFF388F70)),
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
                          const Divider(height: 1.5, color: Color(0xFFD8D8D8)),
                          const SizedBox(height: 14),

                          // Product Details
                          Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(
                            'Fresh, juicy Indian tomatoes perfect for curries, salads, and sauces. '
                            'Grown organically with no artificial preservatives. Rich in lycopene and vitamin C. '
                            'Each tomato is hand-picked at peak ripeness for optimal flavor.',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
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
