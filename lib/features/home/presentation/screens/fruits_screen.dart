import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vegmart/core/widgets/product_add_popup.dart';
import 'package:vegmart/core/widgets/product_card.dart';
import 'package:vegmart/features/product/presentation/screens/product_detail_screen.dart';

class FruitsScreen extends StatefulWidget {
  const FruitsScreen({super.key});
  @override
  State<FruitsScreen> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  final List<Map<String, dynamic>> products = [];

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
    final isTablet = screenWidth >= 500 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024 && screenWidth < 1400;
    final isExtraLargeDesktop = screenWidth > 1400;
    final crossAxisCount =
    isExtraLargeDesktop
        ? 7
        : isDesktop
        ? 6
        : (isTablet ? 4 : 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFFF8F9FA),
        centerTitle: true,
        title: Text("Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : null),),
        actions: [IconButton(icon: Icon(Icons.search_rounded, color: isDarkMode ? Colors.white : null), onPressed: () {})],
      ),
      body: SingleChildScrollView( child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isExtraLargeDesktop ? 15 : 8.0,
            mainAxisSpacing: 10.0,
            mainAxisExtent: 328,
          ),
          itemCount: products.length,
          itemBuilder:
              (context, index) => ProductCard(
            title: products[index]['title'],
            imagePath: products[index]['image'],
            currentPrice: products[index]['currentPrice'],
            originalPrice: products[index]['originalPrice'],
            tag: 'Most Bought',
            quantity: products[index]['quantity'],
            discount: products[index]['discount'],
            useCompactLayout: false,
            onProductTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen()));
            },
            onAddPressed: () {
              ProductAddPopup.show(context);
            },
          ).animate(delay: (100 * index).ms).fadeIn(duration: 300.ms).slideY(begin: 0.1),
        ),
      ),
      ),
    );
  }
}
