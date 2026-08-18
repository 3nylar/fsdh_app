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


  /// Deep navy of the info banner on the Add BVN screen.
  static const Color banner = Color(0xFF1B2B4B);

  static const Color scaffold = Color(0xFFF2F4F7);

  static const Color heading = Color(0xFF14243B);
  static const Color body = Color(0xFF344054);
  static const Color label = Color(0xFF7B8794);
  static const Color hint = Color(0xFF98A2B3);

  static const Color borderFocused = accent;

  static const Color warning = Color(0xFFF2A73B);

  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledText = Color(0xFFF3F4F6);

  /// Pale grey-blue of the tooltip bubble and the "Skip Step" chip.
  static const Color tooltip = Color(0xFFDFE7ED);

  /// Inactive segment of the password strength meter.
  static const Color meterEmpty = Color(0xFFB8C7D1);

  // --- Dashboard-specific tokens ---

  /// Deepest navy at the base of the dashboard hero, behind the
  /// wallet/portfolio card and the decorative ring graphic.
  static const Color heroDeep = Color(0xFF041B34);

  /// Soft shadow tint under the floating white cards on the dashboard.
  static const Color cardShadow = Color(0x1A001526);

  /// Background of the "1 of 2" page pill on the wallet/portfolio card.
  static const Color pillBg = Color(0xFFEFF3F6);
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

