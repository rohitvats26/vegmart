import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vegmart/features/home/data/models/category.dart';
import 'package:vegmart/features/home/presentation/screens/all_products_screen.dart';
import 'package:vegmart/features/home/presentation/screens/fruits_screen.dart';
import 'package:vegmart/features/home/presentation/screens/vegetables_screen.dart';
import 'package:vegmart/features/home/presentation/widgets/header.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  final PageController _categoryPageController = PageController();


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

  }

  void _handleCategoryChanged(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _categoryPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _categoryPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            Header(scrollController: _scrollController,
              onSearch: (query) {},
              onCategoryChanged: _handleCategoryChanged,
              onCartPressed: () {},
              cartItemCount: 10,
              selectedCategoryIndex: _selectedCategoryIndex,
            ),
          ];
        },
        body: PageView(
          controller: _categoryPageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _selectedCategoryIndex = index);
          },
          children: const [
            AllProductsScreen(),
            VegetablesScreen(),
            FruitsScreen(),
          ],
        ),
      ),
    );
  }
}
