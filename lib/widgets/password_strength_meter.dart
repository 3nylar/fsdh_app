import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Four-segment strength bar under the password field.
///
/// Colour follows the score rather than the segment: red at 1, amber at
/// 2, green at 3 and 4. One mockup frame shows three green segments
/// beside a red fourth, which reads as a rendering artifact — mixing
/// "strong" and "danger" in one bar tells the user two things at once.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.score});

  /// 0–4, from Validators.passwordScore.
  final int score;

  Color get _color {
    if (score <= 1) return AppColors.error;
    if (score == 2) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final filled = i < score;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == 3 ? 0 : 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 4,
              decoration: BoxDecoration(
                color: filled ? _color : AppColors.meterEmpty,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
