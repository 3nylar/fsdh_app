import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../utils/formatters.dart';
import '../theme/decorative_rings.dart';

/// The navy section at the top of the dashboard: greeting/title row,
/// the "verify your email" banner, and the headline dollar balance.
///
/// Bottom padding is left generous on purpose — the wallet/portfolio
/// card floats over the lower edge of this section (see
/// [DashboardScreen]), so this widget's background needs to extend
/// behind it.
class BalanceHero extends StatelessWidget {
  const BalanceHero({
    super.key,
    required this.dollarBalance,
    required this.hidden,
    required this.onToggleHidden,
    this.userInitial = 'O',
    this.showVerifyBanner = true,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  final double dollarBalance;
  final bool hidden;
  final VoidCallback onToggleHidden;
  final String userInitial;
  final bool showVerifyBanner;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.heroDeep],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              top: -10,
              right: -20,
              child: DecorativeRings(size: 190),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onNotificationTap,
                      icon: const Icon(Icons.notifications_none_rounded,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: onAvatarTap,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.accentBg,
                        child: Text(
                          userInitial,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (showVerifyBanner) ...[
                  const SizedBox(height: 18),
                  const _VerifyEmailBanner(),
                ],
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Dollar Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onToggleHidden,
                      child: Icon(
                        hidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 17,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  hidden ? '•••• ••••' : formatMoney(dollarBalance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyEmailBanner extends StatelessWidget {
  const _VerifyEmailBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.banner,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.white, size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "You're unable to transact now. Please verify your email "
              'address.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
