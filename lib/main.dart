import 'package:flutter/material.dart';
import 'package:vegmart/core/presentation/layouts/main_layout.dart';
import 'package:vegmart/core/theme/app_theme.dart';
import 'package:vegmart/features/auth/presentation/screens/login_screen.dart';


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
      home: MainLayout(),//LoginScreen(permissionGranted: permissionGranted),
    );
  }
}