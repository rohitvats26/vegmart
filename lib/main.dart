import 'package:flutter/material.dart';
import 'package:vegmart/core/theme/app_theme.dart';
import 'package:vegmart/features/home/presentation/screens/home_screen.dart';
import 'package:vegmart/features/product/presentation/screens/product_search_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isGranted = true; //await NotificationService.requestPermission();
  runApp(MyApp(permissionGranted: isGranted));
}

class MyApp extends StatelessWidget {
  final bool permissionGranted;

  const MyApp({super.key, required this.permissionGranted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: ProductSearchScreen(),//LoginScreen(permissionGranted: permissionGranted),
    );
  }
}