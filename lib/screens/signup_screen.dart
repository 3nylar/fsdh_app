import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './registration_screen.dart';
import '../state/onboarding_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingController(),
      child: const RegistrationScreen(),
    );
  }
}
