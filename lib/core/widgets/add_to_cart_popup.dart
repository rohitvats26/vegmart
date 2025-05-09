import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vegmart/features/add_to_cart/presentation/screens/add-to-cart-screen.dart';

class AddToCartPopup {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: Navigator.of(context),
      ),
      builder: (context) => const AddToCartSheet(),
    );
  }
}

class AddToCartSheet extends StatefulWidget {
  const AddToCartSheet({super.key});

  @override
  State<AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<AddToCartSheet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;
  late bool showCart = false;
  final Map<String, int> itemQuantities = {'Cabbage (Patta Gobi)': 1, 'Lady\'s Finger (Bhindi)': 1, 'Tender Coconut': 1};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _translateAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementQuantity(String itemName) {
    setState(() {
      itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String itemName) {
    setState(() {
      if ((itemQuantities[itemName] ?? 0) > 1) {
        itemQuantities[itemName] = itemQuantities[itemName]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1E2125) : Colors.white;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _translateAnimation.value),
          child: Opacity(opacity: _opacityAnimation.value, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [
            BoxShadow(color: Color(0xFFEDECF1).withOpacity(1), blurRadius: 20, offset: Offset(0, 2), spreadRadius: 0),
            BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 0, offset: Offset(0, 30), spreadRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.green),
              child: Center(child: Image.asset('assets/celebration.png')),
            ),*/
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 20, 20),
              decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Stacked images showing multiple items
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 10,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFD8D8D8), width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 7,
                              top: 10,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFD8D8D8), width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 14,
                              top: 10,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFD8D8D8), width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/vegetables/carrots.jpg'), // Replace with your image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '9 Items',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'You save ₹228',
                                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => {print('called'),
                      openAddToCartScreen() },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                    child: const Text(
                      'Go to cart',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openAddToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToCartScreen()),
    );
  }
}
