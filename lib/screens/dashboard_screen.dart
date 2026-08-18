import 'package:flutter/material.dart';

import '../../models/dashboard_models.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dashboard/balance_hero.dart';
import '../../widgets/dashboard/dashboard_bottom_nav.dart';
import '../../widgets/dashboard/fund_option_section.dart';
import '../../widgets/dashboard/next_steps_section.dart';
import '../../widgets/dashboard/talk_to_us_button.dart';
import '../../widgets/dashboard/upgrade_account_card.dart';
import '../../widgets/dashboard/wallet_pager_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _balancesHidden = false;
  int _navIndex = 0;

  // Stand-in data. Swap for values from the wallet/portfolio API once
  // it's wired up — the widgets below only depend on these models.
  final _accounts = const [
    WalletAccount(
      title: 'My Wallet',
      balanceLabel: 'Naira Balance',
      amount: 567896.00,
      currencySymbol: '₦',
      accountNumber: '1102335745',
      bankName: 'UBA',
    ),
    WalletAccount(
      title: 'My Portfolio',
      balanceLabel: 'Dollar Balance',
      amount: 2000098293.09,
      currencySymbol: '\$',
    ),
  ];

  final _nextSteps = const [
    NextStepItem(icon: Icons.account_balance_wallet_outlined, label: 'Fund Wallet'),
    NextStepItem(icon: Icons.apartment_outlined, label: 'Create Plan'),
  ];

  final _investmentOptions = const [
    FundOption(badgeText: 'CIF', ytdLabel: 'YTD %', name: 'Coral Income Fund'),
    FundOption(badgeText: 'CIF', ytdLabel: 'YTD %', name: 'Coral Income Fund'),
    FundOption(badgeText: 'CEF', ytdLabel: 'YTD %', name: 'Coral Equity Fund'),
  ];

  final _savingsOptions = const [
    FundOption(
      badgeText: 'PSG',
      ytdLabel: 'YTD %',
      name: 'Personal Savings Goal',
      badgeColor: AppColors.success,
    ),
    FundOption(
      badgeText: 'GSG',
      ytdLabel: 'YTD %',
      name: 'Group Savings Goal',
      badgeColor: AppColors.success,
    ),
    FundOption(
      badgeText: 'PSP',
      ytdLabel: 'YTD %',
      name: 'Planned Savings',
      badgeColor: AppColors.success,
    ),
  ];

  void _toggleHidden() => setState(() => _balancesHidden = !_balancesHidden);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      extendBody: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BalanceHero(
              dollarBalance: _accounts.last.amount,
              hidden: _balancesHidden,
              onToggleHidden: _toggleHidden,
              onNotificationTap: () {},
              onAvatarTap: () {},
            ),
            // Pull the wallet card up so it overlaps the bottom of the
            // navy hero, matching the mockup.
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WalletPagerCard(
                  accounts: _accounts,
                  hidden: _balancesHidden,
                  onToggleHidden: _toggleHidden,
                  onFundWallet: () {},
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -44),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    UpgradeAccountCard(
                      percentComplete: 25,
                      onUpgrade: () {},
                    ),
                    const SizedBox(height: 24),
                    NextStepsSection(items: _nextSteps),
                    const SizedBox(height: 24),
                    FundOptionSection(
                      title: 'Investment Options',
                      options: _investmentOptions,
                      onSeeAll: () {},
                    ),
                    const SizedBox(height: 24),
                    FundOptionSection(
                      title: 'Savings Options',
                      options: _savingsOptions,
                      onSeeAll: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: TalkToUsButton(onPressed: () {}),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}
