import 'package:flutter/material.dart';

/// Single source of truth for the palette used across Login, Onboarding,
/// and Splash so the three original standalone files stop diverging
/// (e.g. 0xFF004987 vs 0xFF004886 for "primary blue").
class AppColors {
  AppColors._();

  static const primary = Color(0xFF004987); // main navy blue
  static const accent = Color(0xFF009ADE); // cyan links / fingerprint
  static const accentBg = Color(0xFFE6F5FC); // light cyan container bg
  static const success = Color(0xFF00B167); // green check / active checkbox
  static const error = Color(0xFFE8564B); // invalid credential red

  static const textPrimary = Color(0xFF001526);
  static const textSecondary = Color(0xFF525F66);
  static const textMuted = Color(0xFF65727B);
  static const textFaint = Color(0xFF757575);

  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF2F4F7);
  static const border = Color(0xFFD8DEE2);
  static const skipChipBg = Color(0xFFE2F1F8);
  static const indicatorInactive = Color(0xFFDADADA);
}

class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
    fontSize: 24,
  );

  static const subheading = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    color: AppColors.textFaint,
    fontSize: 12,
  );
}