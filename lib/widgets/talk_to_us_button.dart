import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

/// Navy "Talk to Us" pill that floats above the bottom nav.
class TalkToUsButton extends StatelessWidget {
  const TalkToUsButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(24),
      elevation: 4,
      shadowColor: AppColors.cardShadow,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Talk to Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
