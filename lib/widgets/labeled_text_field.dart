import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum FieldStatus { none, success, error }

/// A labeled text field that can show the three visual states from the
/// login screenshots: neutral, valid (green border + check), and
/// invalid (red border + inline error message).
class LabeledTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final FieldStatus status;
  final String? errorText;
  final String? successText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputType? keyboardType;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.status = FieldStatus.none,
    this.errorText,
    this.successText,
    this.onChanged,
    this.enabled = true,
    this.keyboardType,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  Color get _borderColor {
    switch (widget.status) {
      case FieldStatus.success:
        return AppColors.success;
      case FieldStatus.error:
        return AppColors.error;
      case FieldStatus.none:
        return AppColors.border;
    }
  }

  Widget? get _statusIcon {
    if (widget.status == FieldStatus.error) {
      return const Icon(
          Icons.error,
          color: AppColors.error
      );
    }
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textMuted,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }
    if (widget.status == FieldStatus.success) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.success
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: 'Placeholder',
            suffixIcon: _statusIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _borderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _borderColor,
                width: 1.5
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _borderColor,
                width: 1.5
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.border,
                width: 1
              ),
            ),
          ),
        ),
        if (widget.status == FieldStatus.error && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12
              ),
            ),
          ),
        if (widget.status == FieldStatus.success && widget.successText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.successText!,
              style: const TextStyle(color: AppColors.success, fontSize: 12),
            ),
          ),
      ],
    );
  }
}