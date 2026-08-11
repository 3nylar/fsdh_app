import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

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
      // Single app-wide theme. Previously the onboarding flow got its
      // field styling from a second MaterialApp nested in SignUpScreen;
      // that nesting broke navigation, so the theme it carried
      // (AppTheme.light, which configures inputDecorationTheme) is now
      // applied here at the root for every screen.
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
