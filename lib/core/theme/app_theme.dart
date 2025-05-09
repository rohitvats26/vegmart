import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegmart/core/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: Color(0xFF2A9F75),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2A9F75),
      secondary: Color(0xFFFF7D33),
      tertiary: Color(0xFF6C5CE7),
      surface: Colors.white,
      background: Color(0xFFF8F9FA),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Color(0xFF212529)),
      titleTextStyle: TextStyle(
        color: Color(0xFF212529),
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF212529),
        fontFamily: 'SFProDisplay',
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF212529),
        fontFamily: 'SFProDisplay',
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF495057),
        fontFamily: 'SFProText',
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF6C757D),
        fontFamily: 'SFProText',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFADB5BD),
        fontFamily: 'SFProText',
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppColors.light,
    ],
  );

  static final darkTheme = ThemeData(
    primaryColor: Color(0xFF2A9F75),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2A9F75),
      secondary: Color(0xFFFF9E80),
      tertiary: Color(0xFFA389FF),
      surface: Color(0xFF1E2125),
      background: Color(0xFF121416),
    ),
    scaffoldBackgroundColor: const Color(0xFF121416),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Color(0xFF1E2125),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFProDisplay',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'SFProDisplay',
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontFamily: 'SFProDisplay',
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE9ECEF),
        fontFamily: 'SFProText',
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFFCED4DA),
        fontFamily: 'SFProText',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFADB5BD),
        fontFamily: 'SFProText',
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppColors.dark,
    ],
  );
}