import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vegmart/features/add_to_cart/data/models/cart_item.dart';
import 'package:vegmart/features/add_to_cart/presentation/widgets/date_slot_card.dart';
import 'package:vegmart/features/add_to_cart/presentation/widgets/slide_to_pay.dart';
import 'package:vegmart/features/add_to_cart/presentation/widgets/time_slot_card.dart';
import 'package:vegmart/features/add_to_cart/presentation/widgets/cart_Item_card.dart';

class AddToCartScreen extends StatefulWidget {
  get amount => 235;
  late final Future<bool> Function() onPaymentProcess;
  late final VoidCallback? onSuccess;
  late final VoidCallback? onFailure;

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedDateIndex = -1;
  int _selectedTimeSlotIndex = -1;
  TextEditingController _instructionsController = TextEditingController();

  // Generate next 7 dates
  final List<DateTime> _availableDates = List.generate(5, (index) => DateTime.now().add(Duration(days: index)));

  // Time slots
  final List<String> _timeSlots = ['7:00 AM - 10:00 AM', '10:00 AM - 1:00 PM', '1:00 PM - 3:00 PM', '3:00 PM - 5:00 PM'];

  final List<CartItemModel> cartItems = [
    CartItemModel(
      title: 'Cabbage (Patta Gobi)',
      quantity: '1 Piece x 2',
      price: 43,
      originalPrice: 58,
      quantityCount: 2,
      imageUrl: 'assets/vegetables/Muskmelon.jpeg',
    ),
    CartItemModel(
      title: 'Tender Coconut',
      quantity: '1 Piece',
      price: 255,
      originalPrice: 318,
      quantityCount: 3,
      imageUrl: 'assets/vegetables/carrots.jpg',
    ),
    CartItemModel(
      title: 'Tender Coconut',
      quantity: '1 Piece',
      price: 255,
      originalPrice: 318,
      quantityCount: 3,
      imageUrl: 'assets/vegetables/Muskmelon.jpeg',
    ),
    CartItemModel(
      title: 'Tender Coconut',
      quantity: '1 Piece',
      price: 255,
      originalPrice: 318,
      quantityCount: 3,
      imageUrl: 'assets/vegetables/carrots.jpg',
    ),
    CartItemModel(
      title: 'HALDIRAM DELHI Punjabi Tadka',
      quantity: '1 Pack',
      price: 54,
      quantityCount: 1,
      imageUrl: 'assets/vegetables/Muskmelon.jpeg',
    ),
    CartItemModel(title: 'Potato', quantity: '1 kg', price: 35, quantityCount: 1, imageUrl: 'assets/vegetables/carrots.jpg'),
    CartItemModel(title: 'Carrot', quantity: '500 g', price: 20, quantityCount: 1, imageUrl: 'assets/vegetables/Muskmelon.jpeg'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void updateQuantity(int index, int delta) {
    setState(() {
      final newCount = cartItems[index].quantityCount + delta;
      if (newCount >= 0) {
        cartItems[index] = cartItems[index].copyWith(quantityCount: newCount);
        _animationController.forward(from: 0);
      }
    });
  }

  Future<bool> processPayment(double amount) async {
    // Simulate API call or payment processing
    await Future.delayed(Duration(seconds: 2));

    // Return true for success, false for failure
    // In real app, this would be your actual payment logic
    return true; // Change to false to test failure case
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isSmallMobile = screenSize.width <= 390; // iPhone 5/SE
    final isMobile = screenSize.width <= 480; // Most phones in portrait
    final isLargeMobile = screenSize.width <= 600; // Large phones/phablets
    final isTablet = screenSize.width <= 900; // Tablets
    // Anything larger than 900 is considered desktop

    // Responsive sizing
    final double paddingValue =
        isSmallMobile
            ? 14.0
            : isMobile
            ? 16.0
            : isLargeMobile
            ? 18.0
            : isTablet
            ? 20.0
            : 22.0;

    final double iconSize =
        isSmallMobile
            ? 22.0
            : isMobile
            ? 25.0
            : isLargeMobile
            ? 25.0
            : isTablet
            ? 30.0
            : 28.0;

    final double fontSizeSmall =
        isSmallMobile
            ? 12.0
            : isMobile
            ? 14.0
            : isLargeMobile
            ? 16.0
            : isTablet
            ? 18.0
            : 20.0;

    final double fontSizeMedium =
        isSmallMobile
            ? 14.0
            : isMobile
            ? 16.0
            : isLargeMobile
            ? 18.0
            : isTablet
            ? 20.0
            : 22.0;

    final double fontSizeLarge =
        isSmallMobile
            ? 16.0
            : isMobile
            ? 18.0
            : isLargeMobile
            ? 20.0
            : isTablet
            ? 22.0
            : 24.0;

    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantityCount);

    // Colors for dark and light themes
    final backgroundColor = isDarkMode ? Colors.grey[900] : Color(0xFFF8F9FA);
    final appBarColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final shadowColor = isDarkMode ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.05);
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: iconColor, size: iconSize),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.home, color: iconColor, size: iconSize * 0.9),
                SizedBox(width: 4),
                Text('HOME', style: theme.textTheme.bodyLarge?.copyWith(color: textColor, fontSize: fontSizeSmall)),
                Icon(Icons.keyboard_arrow_down_outlined, color: iconColor, size: iconSize * 1.25),
              ],
            ),
            Row(
              children: [
                Text(
                  'I-24, Second Floor Honour Homes...',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: fontSizeSmall * 0.9, color: secondaryTextColor),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Savings Banner
          Container(
            padding: EdgeInsets.symmetric(vertical: paddingValue * 0.8, horizontal: paddingValue),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode ? [Colors.green[800]!, Colors.green[700]!] : [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.discount, color: isDarkMode ? Colors.white : Color(0xFF2E7D32), size: iconSize),
                SizedBox(width: 8),
                Text(
                  'You saved ₹213 on this order!',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(padding: EdgeInsets.only(bottom: paddingValue)),
                // Order Summary Header
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Review your Order',
                          style: TextStyle(fontSize: fontSizeMedium, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        Text(
                          '$totalItems Items',
                          style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: fontSizeMedium),
                        ),
                      ],
                    ),
                  ),
                ),

                // Cart Items List
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(paddingValue, paddingValue * 0.5, paddingValue, paddingValue * 0.5),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(paddingValue * 0.5),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        children: List.generate(cartItems.length, (index) {
                          final item = cartItems[index];
                          return CartItemWidget(item: item, onQuantityChanged: (delta) => updateQuantity(index, delta));
                        }),
                      ),
                    ),
                  ),
                ),

                // Add more items
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(paddingValue, paddingValue * 0.5, paddingValue, paddingValue * 0.5),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(paddingValue * 0.8),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'Missed Something? ',
                              style: TextStyle(fontSize: fontSizeSmall, color: secondaryTextColor),
                              children: [
                                TextSpan(
                                  text: 'Add more items',
                                  style: TextStyle(
                                    fontSize: fontSizeSmall,
                                    color: Colors.orange[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          print('Add more items clicked');
                                        },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Coupon Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(paddingValue, paddingValue * 0.5, paddingValue, paddingValue * 0.5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(paddingValue),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(paddingValue * 0.6),
                              decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.local_offer, color: Colors.white, size: iconSize * 0.8),
                            ),
                            SizedBox(width: paddingValue),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Apply Coupon Code',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeSmall, color: textColor),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Save more with coupons',
                                    style: TextStyle(color: secondaryTextColor, fontSize: fontSizeSmall * 0.9),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: iconSize * 0.8, color: secondaryTextColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bill Details Section
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(paddingValue, paddingValue * 0.5, paddingValue, paddingValue * 0.5),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 2))],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(paddingValue, paddingValue * 0.8, paddingValue, paddingValue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.receipt_1, color: theme.primaryColor, size: iconSize + 5),
                                SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'To Pay',
                                      style: TextStyle(fontSize: fontSizeSmall, fontWeight: FontWeight.w600, color: textColor),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Incl. all taxes and charges',
                                      style: TextStyle(fontSize: fontSizeSmall * 0.9, color: secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '₹190',
                                          style: TextStyle(
                                            fontSize: fontSizeSmall * 0.9,
                                            decoration: TextDecoration.lineThrough,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          '₹164',
                                          style: TextStyle(
                                            fontSize: fontSizeSmall * 0.9,
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: paddingValue * 0.5, vertical: paddingValue * 0.3),
                                      decoration: BoxDecoration(
                                        color: isDarkMode ? Colors.green[900] : Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'SAVING ₹106',
                                        style: TextStyle(
                                          fontSize: fontSizeSmall * 0.7,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: paddingValue * 0.8),
                                Icon(Icons.arrow_forward_ios, size: iconSize * 0.8, color: secondaryTextColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Delivery Date & time Section
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(paddingValue, paddingValue * 0.5, paddingValue, paddingValue * 0.5),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 2))],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(paddingValue * 0.8, paddingValue * 0.8, paddingValue, paddingValue * 0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Delivery Date',
                              style: TextStyle(fontSize: fontSizeSmall, fontWeight: FontWeight.bold, color: textColor),
                            ),
                            SizedBox(height: paddingValue * 0.8),
                            Column(
                              children: [
                                // Horizontal date picker
                                SizedBox(
                                  height:
                                      isSmallMobile
                                          ? 60
                                          : isMobile
                                          ? 75
                                          : 110,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _availableDates.length,
                                    itemBuilder: (context, index) {
                                      final date = _availableDates[index];
                                      final isSelected = index == _selectedDateIndex;
                                      return Container(
                                        width:
                                            isSmallMobile
                                                ? 58
                                                : isMobile
                                                ? 65
                                                : 110,
                                        margin: EdgeInsets.only(
                                          right:
                                              index == _availableDates.length - 1
                                                  ? 0
                                                  : isSmallMobile || isMobile || isLargeMobile
                                                  ? 8
                                                  : 30,
                                        ),
                                        child: DateChip(
                                          date: date,
                                          isSelected: isSelected,
                                          onTap: () => setState(() => _selectedDateIndex = index),
                                          isDarkMode: isDarkMode,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: paddingValue),
                            Text(
                              'Select Delivery Time',
                              style: TextStyle(fontSize: fontSizeSmall, fontWeight: FontWeight.bold, color: textColor),
                            ),
                            SizedBox(height: paddingValue * 0.8),
                            SizedBox(
                              height: isSmallMobile || isMobile || isLargeMobile ? 100 : 150,
                              child: GridView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _timeSlots.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isSmallMobile || isMobile || isLargeMobile || isTablet ? 2 : 4,
                                  // Number of items per row
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio:
                                      isSmallMobile || isMobile || isLargeMobile ? 4 : 6, // Adjust based on your design
                                ),
                                itemBuilder: (context, index) {
                                  return TimeSlotCard(
                                    slot: _timeSlots[index],
                                    isSelected: index == _selectedTimeSlotIndex,
                                    onTap: () => setState(() => _selectedTimeSlotIndex = index),
                                    isDarkMode: isDarkMode,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom:
                        isSmallMobile
                            ? 125
                            : isMobile
                            ? 165
                            : 200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Fixed Proceed Button
      bottomSheet: SlideToPay(
        amount: 675.00,
        onPaymentProcess: () async {
          final success = await processPayment(675.00);
          return success;
        },
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment successful!')));
        },
        onFailure: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed. Please try again.')));
        },
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false, bool isTotal = false, bool showInfo = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final screenSize = MediaQuery.of(context).size;
    final isSmallMobile = screenSize.width <= 375;
    final fontSizeSmall = isSmallMobile ? 10.0 : 12.0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSizeSmall,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                ),
              ),
              if (showInfo)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Taxes and Charges'),
                              content: Text('Includes 5% GST and other applicable charges as per government regulations.'),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                            ),
                      );
                    },
                    child: Icon(Icons.info_outline, size: fontSizeSmall, color: secondaryTextColor),
                  ),
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? fontSizeSmall * 1.2 : fontSizeSmall,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isTotal
                      ? theme.primaryColor
                      : isDiscount
                      ? Colors.green
                      : textColor,
            ),
          ),
        ],
      ),
    );
  }
}
