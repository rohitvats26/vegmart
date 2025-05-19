import 'package:flutter/material.dart';
import 'package:vegmart/core/presentation/layouts/navigation_bottom_bar.dart';
import 'package:vegmart/features/add_to_cart/presentation/screens/add-to-cart-screen.dart';
import 'package:vegmart/features/home/presentation/screens/flash_deal_screen.dart';
import 'package:vegmart/features/home/presentation/screens/home_screen.dart';
import 'package:vegmart/features/order/presentation/screens/orders_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 3) { // Cart index
      // Navigate to full-screen cart
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddToCartScreen()),
      );
      // After returning from cart, maintain the previous selection
      setState(() {
        _selectedIndex = _selectedIndex; // Stays the same
      });

    } else {
      // Regular tab navigation
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping between pages
        children: <Widget>[
          const HomeScreen(),
          OrdersScreen(),
          const FlashDealScreen(),
          Center(child: SizedBox.shrink()),
          const Center(child: Text('Profile Screen')),
        ],
      ),
      bottomNavigationBar: NavigationBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}