import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/onboarding_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'success_screen.dart';

class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({super.key});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Fire the confirmation mail as soon as the screen appears, since
    // the copy tells the user it has already been sent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingController>().sendConfirmationEmail();
    });
  }

  Future<void> _finish({required bool confirmed}) async {
    final controller = context.read<OnboardingController>();
    if (confirmed) controller.markEmailConfirmed();

    final ok = await controller.completeRegistration();
    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.error ?? 'Something went wrong.'),
        ),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SuccessScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<OnboardingController>().busy;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.accent),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Text(
                        'Email Confirmation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
                    onPressed: () {},
                    tooltip: 'Notifications',
                  ),
                ],
              ),
              const SizedBox(height: 90),

              const Text(
                "We've sent a mail to your email address. Kindly confirm your "
                'email address to activate your wallet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 74),

              InverseButton(
                label: 'Confirm Email',
                onPressed: busy ? null : () => _finish(confirmed: true),
              ),
              const SizedBox(height: 36),

              // Skipping still creates the wallet — the copy frames
              // confirmation as an activation step, not a hard gate.
              InverseButton(
                label: 'Skip',
                onPressed: busy ? null : () => _finish(confirmed: false),
              ),

              if (busy) ...[
                const SizedBox(height: 32),
                const Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
