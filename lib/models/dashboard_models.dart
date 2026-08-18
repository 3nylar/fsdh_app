import 'package:flutter/material.dart';

/// One page of the "My Wallet" / "My Portfolio" swipeable card.
class WalletAccount {
  const WalletAccount({
    required this.title,
    required this.balanceLabel,
    required this.amount,
    this.currencySymbol = '\$',
    this.accountNumber,
    this.bankName,
  });

  final String title;
  final String balanceLabel;
  final double amount;
  final String currencySymbol;

  /// Null hides the account-number chip (e.g. on the portfolio page).
  final String? accountNumber;
  final String? bankName;
}

/// A tile in the "Next steps" row.
class NextStepItem {
  const NextStepItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
}

/// A card in the "Investment Options" / "Savings Options" carousels.
class FundOption {
  const FundOption({
    required this.badgeText,
    required this.ytdLabel,
    required this.name,
    this.badgeColor,
  });

  final String badgeText;
  final String ytdLabel;
  final String name;
  final Color? badgeColor;
}

/// An entry in the bottom navigation bar.
class DashboardNavItem {
  const DashboardNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
