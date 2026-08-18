import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';
import '../../../theme/app_colors.dart';

const dashboardNavItems = [
  DashboardNavItem(icon: Icons.grid_view_rounded, label: 'Dashboard'),
  DashboardNavItem(icon: Icons.widgets_outlined, label: 'Products'),
  DashboardNavItem(icon: Icons.pie_chart_outline, label: 'Portfolio'),
  DashboardNavItem(icon: Icons.send_outlined, label: 'Transfers'),
  DashboardNavItem(icon: Icons.more_horiz, label: 'More'),
];

/// Bottom tab bar with an active dot under the selected item, matching
/// the mockups (Dashboard / Products / Portfolio / Transfers / More).
class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < dashboardNavItems.length; i++)
                Expanded(
                  child: _NavButton(
                    item: dashboardNavItems[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DashboardNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 22, color: color),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 10.5,
              color: color,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 3),
          AnimatedOpacity(
            opacity: selected ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
