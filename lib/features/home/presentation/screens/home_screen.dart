import 'package:flutter/material.dart';
import 'package:vegmart/core/presentation/layouts/navigation_bottom_bar.dart';
import 'package:vegmart/features/home/presentation/widgets/header.dart';

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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              SliverToBoxAdapter(child: _buildPromoBanner()),
              SliverList(delegate: SliverChildBuilderDelegate((_, index) => _buildProductItem(index), childCount: 20)),
              // Your content slivers here
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBottomBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }

  /*return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              Header(
                deliveryAddress: '123 Main Street, Downtown, City',
                userName: 'John Doe',
                userAvatar: 'assets/assets/avatar1.jpg',
                onLocationTap: () {
                  print('Location tapped');
                },
                onProfileTap: () {
                  print('Profile tapped');
                },
                onSearch: (query) {
                  print('Searching for: $query');
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Again and Local Shop Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 160,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'order_again_icon.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, color: Colors.green, size: 40);
                                  },
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'ORDER AGAIN',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 160,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'local_shop_icon.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, color: Colors.green, size: 40);
                                  },
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'LOCAL SHOP',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Promotional Banner
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
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
                                      const Text(
                                        'Top deal!',
                                        style: TextStyle(color: Color(0xFF2196F3), fontSize: 12, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'FRESH AVOCADO\nUP TO 15% OFF',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF2196F3),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          minimumSize: const Size(0, 36),
                                        ),
                                        child: const Text(
                                          'Shop Now',
                                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Image.asset(
                                  'vegetables/avocado.png',
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, color: Colors.red, size: 140);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCarouselDot(true),
                                const SizedBox(width: 4),
                                _buildCarouselDot(false),
                                const SizedBox(width: 4),
                                _buildCarouselDot(false),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Shop by Category Section
                      const Text('Shop by category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryIcon('vegan_icon.png', 'Vegan'),
                          _buildCategoryIcon('meat_icon.png', 'Meat'),
                          _buildCategoryIcon('fruits_icon.png', 'Fruits'),
                          _buildCategoryIcon('milk_icon.png', 'Milk'),
                          _buildCategoryIcon('fish_icon.png', 'Fish'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Today's Special Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Today\'s Special', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See all',
                              style: TextStyle(color: Color(0xFF2196F3), fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          */ /*_buildSpecialItem('vegetables/orange.png', '4.5'),
                          _buildSpecialItem('vegetables/cabbage.png', '4.5'),*/ /*
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          NavigationBottomBar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
        ],
      ),
    );*/

  Widget _buildPromoBanner() {
    return GestureDetector(
      onTap: () {}, // Handle promo tap
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8F3), Color(0xFFFFF0E6)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFC8019).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFFC8019), letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '50% OFF First 3 Orders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333), height: 1.3),
                  ),
                ],
              ),
            ),
            Positioned(right: 16, bottom: 0, child: Image.asset('assets/delivery_bike.jpg', height: 80, width: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(int index) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(color: index.isEven ? Colors.grey[50] : Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text('Product Item ${index + 1}')),
    );
  }
}

Widget _buildCategoryIcon(String imagePath, String label) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            imagePath,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red, size: 40);
            },
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
    ],
  );
}

Widget _buildSpecialItem(String imagePath, String rating) {
  return Container(
    width: 160,
    height: 160,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red, size: 120);
          },
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.yellow, size: 16),
            const SizedBox(width: 5),
            Text(rating, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}

Widget _buildCarouselDot(bool isActive) {
  return Container(
    width: isActive ? 8 : 6,
    height: isActive ? 8 : 6,
    decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? const Color(0xFF2196F3) : Colors.grey[400]),
  );
}
