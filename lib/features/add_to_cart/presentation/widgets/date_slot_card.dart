import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const DateChip({required this.date, required this.isSelected, required this.onTap, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define breakpoints for different screen sizes
    final isSmallMobile = screenWidth <= 390; // Small mobile (e.g., iPhone SE)
    final isMediumMobile = screenWidth <= 480; // Medium mobile
    final isLargeMobile = screenWidth <= 600; // Large mobile (e.g., iPhone Pro Max)
    final isTablet = screenWidth <= 768; // Tablet
    // Anything larger is considered desktop

    // Responsive sizing
    final chipWidth =
        isSmallMobile
            ? 42
            : isMediumMobile
            ? 46
            : isLargeMobile
            ? 50
            : isTablet
            ? 65
            : 75; // Desktop

    final dayFontSize =
        isSmallMobile
            ? 10
            : isMediumMobile
            ? 11
            : isLargeMobile
            ? 12
            : isTablet
            ? 15
            : 18; // Desktop

    final dateFontSize =
        isSmallMobile
            ? 10
            : isMediumMobile
            ? 12
            : isLargeMobile
            ? 13
            : isTablet
            ? 17
            : 20; // Desktop

    final monthFontSize =
        isSmallMobile
            ? 10
            : isMediumMobile
            ? 11
            : isLargeMobile
            ? 12
            : isTablet
            ? 15
            : 18; // Desktop

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: chipWidth.toDouble(),
        decoration: BoxDecoration(
          color: isSelected ? (isDarkMode ? Colors.green[700] : Colors.green) : (isDarkMode ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(12), // Slightly larger radius for better look
          border: Border.all(
            color: isSelected ? Colors.transparent : (isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 6, spreadRadius: 2)] : null,
        ),
        padding: EdgeInsets.all(isSmallMobile ? 4 : 6),
        margin: EdgeInsets.symmetric(horizontal: 4),
        // Add some horizontal margin
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date), // Day (Mon, Tue, etc.)
              style: TextStyle(
                fontSize: dayFontSize.toDouble(),
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(height: isSmallMobile ? 2 : 4),
            Text(
              date.day.toString(), // Date number
              style: TextStyle(
                fontSize: dateFontSize.toDouble(),
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            SizedBox(height: isSmallMobile ? 1 : 2),
            Text(
              DateFormat('MMM').format(date), // Month (Jan, Feb, etc.)
              style: TextStyle(
                fontSize: monthFontSize.toDouble(),
                color: isSelected ? Colors.white.withOpacity(0.9) : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
