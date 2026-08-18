import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/dashboard_models.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/formatters.dart';
import '../theme/decorative_rings.dart';

/// The white card that floats over the bottom edge of [BalanceHero],
/// paging between the wallet (Naira) and portfolio (Dollar) summaries.
class WalletPagerCard extends StatefulWidget {
  const WalletPagerCard({
    super.key,
    required this.accounts,
    this.hidden = false,
    this.onToggleHidden,
    this.onFundWallet,
  });

  final List<WalletAccount> accounts;
  final bool hidden;
  final VoidCallback? onToggleHidden;
  final VoidCallback? onFundWallet;

  @override
  State<WalletPagerCard> createState() => _WalletPagerCardState();
}

class _WalletPagerCardState extends State<WalletPagerCard> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int delta) {
    final next = (_page + delta).clamp(0, widget.accounts.length - 1);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      // A fixed height keeps every page the same size so the PageView
      // doesn't jump around as the user swipes.
      height: 236,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            const Positioned(
              top: -30,
              right: -30,
              child: DecorativeRings(
                size: 170,
                color: AppColors.primary,
                opacity: 0.06,
              ),
            ),
            PageView.builder(
              controller: _controller,
              itemCount: widget.accounts.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _AccountPage(
                account: widget.accounts[i],
                pageIndex: i,
                pageCount: widget.accounts.length,
                hidden: widget.hidden,
                onToggleHidden: widget.onToggleHidden,
                onPrev: i > 0 ? () => _goTo(-1) : null,
                onFundWallet: widget.onFundWallet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountPage extends StatelessWidget {
  const _AccountPage({
    required this.account,
    required this.pageIndex,
    required this.pageCount,
    required this.hidden,
    required this.onPrev,
    this.onToggleHidden,
    this.onFundWallet,
  });

  final WalletAccount account;
  final int pageIndex;
  final int pageCount;
  final bool hidden;
  final VoidCallback? onPrev;
  final VoidCallback? onToggleHidden;
  final VoidCallback? onFundWallet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chevron_left,
                size: 20,
                color: onPrev == null
                    ? AppColors.indicatorInactive
                    : AppColors.heading,
              ),
              const SizedBox(width: 2),
              Text(
                account.title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.pillBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${pageIndex + 1} of $pageCount',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                account.balanceLabel,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.label,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onToggleHidden,
                child: Icon(
                  hidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.label,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            hidden
                ? '•••• ••••'
                : formatMoney(account.amount, symbol: account.currencySymbol),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (account.accountNumber != null)
                Expanded(child: _AccountChip(account: account))
              else
                const Spacer(),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onFundWallet,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Fund Wallet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  const _AccountChip({required this.account});

  final WalletAccount account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  account.accountNumber!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
                if (account.bankName != null)
                  Text(
                    account.bankName!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: account.accountNumber!));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account number copied'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'copy',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 3),
                Icon(Icons.copy, size: 13, color: AppColors.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
