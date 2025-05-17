import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderCategoryItem extends StatelessWidget {
  final String text;
  final String icon;
  final bool isSelected;

  const HeaderCategoryItem(this.text, this.icon, this.isSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon above text
          SvgPicture.asset(icon, height: 25, width: 25, color: isSelected ? theme.primaryColor: isDarkMode ? Colors.white : null),
          const SizedBox(height: 4),
          // Category text
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
              isDarkMode && isSelected
                  ? Colors.white
                  : isSelected
                  ? Colors.black
                  : isDarkMode
                  ? const Color(0xFFD1D1D1)
                  : const Color(0xFF757575),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
