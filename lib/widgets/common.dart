import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Back arrow on the left, FSDH logo on the right — the header on every

/// Text stand-in for the FSDH wordmark. Drop the real asset into
/// assets/images/fsdh_logo.png and swap the body for an Image.asset.
class FsdhLogo extends StatelessWidget {
  const FsdhLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          'fsdh',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 30,
            height: 1,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        Text(
          'ASSET MANAGEMENT LTD',
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 6.5,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: AppColors.body,
            ),
          ),
        ],
      ],
    );
  }
}

/// Full-width navy button. Goes flat grey when [onPressed] is null,
/// matching the disabled state throughout the mockups.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.disabledText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          ),
        ),
        child: busy
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}

/// White button on the navy screens (Confirm Email, Go to Dashboard).
class InverseButton extends StatelessWidget {
  const InverseButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.heading,
          disabledBackgroundColor: const Color(0xFFE3E8EE),
          disabledForegroundColor: AppColors.label,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          ),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

/// Grey label above a field, with an optional red asterisk and an
/// optional info icon that toggles the tooltip bubble.
class FieldLabel extends StatelessWidget {
  const FieldLabel(
    this.text, {
    super.key,
    this.required = false,
    this.info,
    this.dark = false,
  });

  final String text;
  final bool required;
  final String? info;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 13.5,
              color: dark ? AppColors.heading : AppColors.label,
              fontWeight: dark ? FontWeight.w600 : FontWeight.w400,
            ),
            children: [
              if (required)
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.error),
                ),
            ],
          ),
        ),
        if (info != null) InfoTooltip(message: info!),
      ],
    );
  }
}

/// The circled "i" that reveals a pale bubble on tap. Uses Flutter's
/// Tooltip with `triggerMode: manual` so it responds to tap rather than
/// long-press, which is what the mockups imply on mobile.
class InfoTooltip extends StatefulWidget {
  const InfoTooltip({super.key, required this.message});

  final String message;

  @override
  State<InfoTooltip> createState() => _InfoTooltipState();
}

class _InfoTooltipState extends State<InfoTooltip> {
  final _key = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: _key,
      message: widget.message,
      triggerMode: TooltipTriggerMode.manual,
      showDuration: const Duration(seconds: 4),
      preferBelow: false,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      textStyle: const TextStyle(
        color: AppColors.heading,
        fontSize: 13,
        height: 1.35,
      ),
      decoration: BoxDecoration(
        color: AppColors.tooltip,
        borderRadius: BorderRadius.circular(6),
      ),
      child: GestureDetector(
        onTap: () => _key.currentState?.ensureTooltipVisible(),
        behavior: HitTestBehavior.opaque,
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Icon(Icons.info_outline, size: 20, color: AppColors.accent),
        ),
      ),
    );
  }
}

/// Label + TextFormField pair used across Registration and Security.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.controller,
    this.hintText = 'Placeholder',
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.suffix,
    this.info,
    this.required = false,
    this.maxLength,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.autovalidateMode,
  });

  final String label;
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final String? info;
  final bool required;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required, info: info),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          maxLength: maxLength,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          autovalidateMode: autovalidateMode,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 15, color: AppColors.heading),
          decoration: InputDecoration(
            hintText: hintText,
            counterText: '',
            suffixIcon: suffix,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Eye toggle for password and PIN fields.
class ObscureToggle extends StatelessWidget {
  const ObscureToggle({super.key, required this.obscured, required this.onTap});

  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 21,
        color: AppColors.heading,
      ),
      tooltip: obscured ? 'Show' : 'Hide',
    );
  }
}
