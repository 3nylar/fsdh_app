import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const FsdhApp());
}

class FsdhApp extends StatelessWidget {
  const FsdhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSDH Asset Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.surface,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}