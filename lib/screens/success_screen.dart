import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stand-in for the isometric document illustration. Drop
              // the real asset in assets/images/ and swap this out.
              const _SuccessMark(),
              const SizedBox(height: 34),

              const Text(
                'Success',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'A wallet has been created for you. Thank you! To enjoy '
                'additional benefits, please update KYC requirements and make '
                'your journey to financial freedom. Invest today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 32),

              InverseButton(
                label: 'Go to Dashboard',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dashboard is outside this flow'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 92,
            width: 78,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Container(
                    height: 3,
                    width: i.isEven ? 46 : 34,
                    color: const Color(0xFFC9D6E2),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 6,
            bottom: 26,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.success,
              child: Icon(Icons.check, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
