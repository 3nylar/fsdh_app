import 'package:flutter/material.dart';

import '../../../models/dashboard_models.dart';
import '../../../theme/app_colors.dart';

/// A titled, horizontally-scrolling row of [FundOption] cards. Used for
/// both "Investment Options" and "Savings Options".
class FundOptionSection extends StatelessWidget {
  const FundOptionSection({
    super.key,
    required this.title,
    required this.options,
    this.onSeeAll,
    this.onOptionTap,
  });

  final String title;
  final List<FundOption> options;
  final VoidCallback? onSeeAll;
  final ValueChanged<FundOption>? onOptionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            const Spacer(),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final option = options[i];
              return _FundOptionCard(
                option: option,
                onTap: onOptionTap == null ? null : () => onOptionTap!(option),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FundOptionCard extends StatelessWidget {
  const _FundOptionCard({required this.option, this.onTap});

  final FundOption option;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final badgeColor = option.badgeColor ?? AppColors.primary;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 168,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: badgeColor.withValues(alpha: 0.12),
                    child: Text(
                      option.badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        option.ytdLabel,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                      const Text(
                        'Annual returns',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                option.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
