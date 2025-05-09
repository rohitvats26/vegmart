import 'package:flutter/material.dart';

class TimeSlotCard extends StatelessWidget {
  final String slot;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const TimeSlotCard({required this.slot, required this.isSelected, required this.onTap, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Define breakpoints for different screen sizes
    final isSmallMobile = screenSize.width <= 390; // iPhone 5/SE
    final isMobile = screenSize.width <= 480; // Most phones in portrait
    final isLargeMobile = screenSize.width <= 600; // Large phones/phablets
    final isTablet = screenSize.width <= 900; // Tablets
    final isDesktop = screenSize.width <= 1024;

    // Calculate values based on screen size
    final double minWidth =
        isSmallMobile
            ? 100
            : isMobile
            ? 110
            : isLargeMobile
            ? 120
            : isTablet
            ? 130
            : isDesktop
            ? 140
            : 150;

    final double fontSize =
        isSmallMobile
            ? 12
            : isMobile
            ? 13
            : isLargeMobile
            ? 14
            : isTablet
            ? 15
            : 16;

    final EdgeInsets padding =
        isSmallMobile
            ? EdgeInsets.symmetric(vertical: 8, horizontal: 10)
            : isTablet
            ? EdgeInsets.symmetric(vertical: 10, horizontal: 12)
            : EdgeInsets.symmetric(vertical: 12, horizontal: 16);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: minWidth),
        decoration: BoxDecoration(
          color: isSelected ? (isDarkMode ? Colors.green[700] : Colors.green) : (isDarkMode ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : (isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
        ),
        padding: padding,
        child: Center(
          child: Text(
            slot,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
