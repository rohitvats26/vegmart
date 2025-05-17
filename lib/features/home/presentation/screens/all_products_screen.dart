import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegmart/core/widgets/product_add_popup.dart';
import 'package:vegmart/core/widgets/product_card.dart';
import 'package:vegmart/features/home/data/models/category.dart';
import 'package:vegmart/features/home/presentation/screens/products_screen.dart';
import 'package:vegmart/features/home/presentation/widgets/category_card.dart';
import 'package:vegmart/features/product/presentation/screens/product_detail_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> imageAssets = ["assets/banners/banner1.png", "assets/banners/banner2.png", "assets/banners/banner3.png"];
  final List<Map<String, dynamic>> products = [];

  final List<Category> categories = const [
    Category('Exotic Fruits', 'assets/images/exotic_fruits.png'),
    Category('Exotic Vegetables', 'assets/images/exotic_vegetables.png'),
    Category('Fresh Fruits', 'assets/images/fresh_fruits.png'),
    Category('Fresh Vegetables', 'assets/images/fresh_vegetables.png'),
    Category('Leaf & Herbs', 'assets/images/leaf.png'),
    Category('Seasonal Specials', 'assets/images/seasonal_specials.png'),
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      products.add({
        'title': 'Medium Spices Pack',
        'image': 'assets/vegetables/Muskmelon.jpeg',
        'currentPrice': '16',
        'originalPrice': '25',
        'quantity': '1 piece',
        'discount': '21%',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 500;
    final isTablet = screenWidth >= 500 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024 && screenWidth < 1400;
    final isExtraLargeDesktop = screenWidth > 1400;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _buildPromoBanner(imageAssets, theme, isDarkMode, isMobile, isTablet, isDesktop, isExtraLargeDesktop)),
        SliverPadding(padding: EdgeInsets.only(top: 12)),
        _buildProductItem('Freshest Veggies', isDarkMode),
        _buildProductItem('Juiciest Fruits', isDarkMode),
        _buildCategoryItem('Categories', isDarkMode),
        _buildProductItem('Deal of the Day', isDarkMode),
        // Your content slivers here
      ],
    );
  }

  Widget _buildPromoBanner(
      List<String> imageAssets,
      ThemeData theme,
      bool isDarkMode,
      bool isMobile,
      bool isTablet,
      bool isDesktop,
      bool isExtraLargeDesktop,
      ) {
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction:
      isExtraLargeDesktop
          ? 0.5
          : isDesktop
          ? 0.6
          : isTablet
          ? 0.7
          : 1.0,
    );
    final inactiveIndicatorColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final itemCount = imageAssets.length;

    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 0),
      height:
      isExtraLargeDesktop
          ? 350
          : isDesktop
          ? 320
          : isTablet
          ? 280
          : 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Full-size Page View
            PageView.builder(
              itemCount: itemCount == 0 ? 0 : itemCount * 100, // Large number for infinite effect
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index % itemCount;
                });
              },
              itemBuilder: (_, index) {
                final actualIndex = index % itemCount;
                return Image.asset(
                  imageAssets[actualIndex],
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  errorBuilder: (_, __, ___) => _buildErrorPlaceholder(isDarkMode),
                );
              },
            ),

            // Page indicators
            if (itemCount > 1)
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    itemCount,
                        (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _currentPage == index ? Colors.white : inactiveIndicatorColor?.withOpacity(0.8),
                            boxShadow:
                            _currentPage == index ? [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 4, spreadRadius: 1)] : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.grey[800] : const Color(0xFFF8F8F8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 48, color: isDarkMode ? Colors.grey[600] : Colors.grey[400]),
            const SizedBox(height: 8),
            Text('Image unavailable', style: TextStyle(color: isDarkMode ? Colors.grey[500] : Colors.grey[600], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String dealHeaderLabel, bool isDarkMode) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dealHeaderLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => ProductsScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('See All', style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.green, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: ProductCard(
                          title: products[index]['title'],
                          imagePath: products[index]['image'],
                          currentPrice: products[index]['currentPrice'],
                          originalPrice: products[index]['originalPrice'],
                          tag: 'Most Bought',
                          imageHeight: 140,
                          quantity: products[index]['quantity'],
                          discount: products[index]['discount'],
                          useCompactLayout: true,
                          onProductTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen()));
                          },
                          onAddPressed: () {
                            ProductAddPopup.show(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String headerLabel, bool isDarkMode) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(headerLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8), // Space between text and divider
                    child: _buildFadingDivider(isDarkMode),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Discover boundless choices with over 500+ handpicked products', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 30),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: categories[index]);
              },
            ),

            SizedBox(height: 16),
            // Your categories content woulrd go here
          ],
        ),
      ),
    );
  }

  Widget _buildFadingDivider(bool isDarkMode) {
    return Container(
      height: 1, // Divider height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            isDarkMode ? Colors.grey[800]!.withOpacity(0) : Colors.grey[300]!.withOpacity(0),
          ],
          stops: [0.0, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}