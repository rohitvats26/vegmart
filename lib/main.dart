import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegmart/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isGranted = true; //await NotificationService.requestPermission();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      tools: const [...DevicePreview.defaultTools],
      builder: (context) => MyApp(permissionGranted: isGranted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool permissionGranted;

  const MyApp({super.key, required this.permissionGranted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HomeScreen(), //LoginScreen(permissionGranted: permissionGranted),
    );
  }
}

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
        fontFamily: 'SF Pro Display',
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
        fontFamily: 'SF Pro Display',
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF212529),
        fontFamily: 'SF Pro Display',
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF495057),
        fontFamily: 'SF Pro Text',
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF6C757D),
        fontFamily: 'SF Pro Text',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFADB5BD),
        fontFamily: 'SF Pro Text',
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
        fontFamily: 'SF Pro Display',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        fontFamily: 'SF Pro Display',
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontFamily: 'SF Pro Display',
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE9ECEF),
        fontFamily: 'SF Pro Text',
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFFCED4DA),
        fontFamily: 'SF Pro Text',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFFADB5BD),
        fontFamily: 'SF Pro Text',
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppColors.dark,
    ],
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color shimmerBase;
  final Color shimmerHighlight;

  const AppColors({
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  static const light = AppColors(
    shimmerBase: Color(0xFFF1F3F5),
    shimmerHighlight: Color(0xFFE9ECEF),
  );

  static const dark = AppColors(
    shimmerBase: Color(0xFF2D333B),
    shimmerHighlight: Color(0xFF373E47),
  );

  @override
  AppColors copyWith({
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColors(
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}
