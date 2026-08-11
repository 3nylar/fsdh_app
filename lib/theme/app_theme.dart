import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double fieldRadius = 8;
  static const double buttonRadius = 8;
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 8);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.scaffold,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.error,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.accent),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.body,
        displayColor: AppColors.heading,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 15),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.borderFocused, width: 1.6),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, width: 1.6),
        // The mockups print the validation message below the field in a
        // smaller red face rather than Material's default.
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 11.5,
          height: 1.3,
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(fieldRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
