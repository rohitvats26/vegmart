import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vegmart/core/presentation/layouts/navigation_bottom_bar.dart';
import 'package:vegmart/core/widgets/product_add_popup.dart';
import 'package:vegmart/features/home/presentation/widgets/header.dart';
import 'package:vegmart/features/product/presentation/screens/product_detail_screen.dart';
import 'package:vegmart/features/product/presentation/widgets/product_card.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  final List<String> imageAssets = ["banners/banner1.png", "banners/banner2.png", "banners/banner3.png"];
  final List<Map<String, dynamic>> products = [
    {
      'title': 'Medium Spices Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '16',
      'originalPrice': '25',
      'quantity': '1 piece',
      'discount': '21%',
    },
    {
      'title': 'Small Bundle Pack',
      'image': 'assets/vegetables/carrots.jpg',
      'currentPrice': '20',
      'originalPrice': '35',
      'quantity': '500gm',
      'discount': '15% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
    {
      'title': 'Big Finite Pack',
      'image': 'assets/vegetables/Muskmelon.jpeg',
      'currentPrice': '32',
      'originalPrice': '45',
      'quantity': '1kg',
      'discount': '10% OFF',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  void _onItemTapped(int index) {
    _animationController.forward().then((_) {
      _animationController.reverse();
      setState(() {
        _selectedIndex = index;
      });
    });
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

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              Header(
                scrollController: _scrollController,
                onSearch: (query) {},
                onCategoryChanged: (index) {},
                onCartPressed: () {},
                cartItemCount: 10,
              ),
              SliverToBoxAdapter(child: _buildPromoBanner(imageAssets, theme, isDarkMode, isMobile, isTablet, isDesktop, isExtraLargeDesktop)),
              SliverPadding(padding: EdgeInsets.only(top: 12),),
              _buildProductItem('Freshest Veggies', isDarkMode),
              _buildProductItem('Juiciest Fruits', isDarkMode),
              _buildProductItem('Deal of the Day', isDarkMode),

              // Your content slivers here
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBottomBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
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
      color: isDarkMode ? Colors.grey[800] : Colors.white,
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
            // Page indicators
            if (itemCount > 1)
              Positioned(
                bottom: 12,
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
                Text(
                    dealHeaderLabel,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                    )
                ),
                TextButton(
                  onPressed: () {
                    // Add navigation logic here
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horizontal date picker
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: ProductCard(
                            title: products[index]['title'],
                            imagePath: products[index]['image'],
                            currentPrice: products[index]['currentPrice'],
                            originalPrice: products[index]['originalPrice'],
                            tag: 'Most Bought',
                            imageHeight: 140,
                            quantity: products[index]['quantity'],
                            discount: products[index]['discount'],
                            onProductTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen()));
                            },
                            onAddPressed: () {
                              ProductAddPopup.show(context);
                            },
                          )
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
}