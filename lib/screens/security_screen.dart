import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fsdh_app/screens/registration_screen.dart';
import 'package:provider/provider.dart';

import '../state/onboarding_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/common.dart';
import '../widgets/password_strength_meter.dart';
import 'upload_documents_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _pin = TextEditingController();
  final _confirmPin = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _submitted = false;

  static const _passwordInfo =
      'This will be used to always log in to the application. Please do not '
      'disclose.';
  static const _pinInfo =
      'This will be used to authorize all transactions on this application. '
      'Please do not disclose.';

  @override
  void dispose() {
    for (final c in [_password, _confirmPassword, _pin, _confirmPin]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _complete =>
      _password.text.isNotEmpty &&
      _confirmPassword.text.isNotEmpty &&
      _pin.text.isNotEmpty &&
      _confirmPin.text.isNotEmpty;

  void _submit() {
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<OnboardingController>().setCredentials(
          password: _password.text,
          pin: _pin.text,
        );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UploadDocumentsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = Validators.passwordScore(_password.text);
    final passwordValid = Validators.passwordMeetsRule(_password.text);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Color(0xFF009ADE),
                      )
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 48,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                onChanged: () => setState(() {}),
                child: ListView(
                  padding: AppTheme.pagePadding.copyWith(bottom: 32),
                  children: [
                    const ScreenTitle('Security'),
                    const SizedBox(height: 24),

                    // ── Password ────────────────────────────────
                    FieldLabel('Create password', info: _passwordInfo),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscurePassword,
                      validator: Validators.password,
                      style:
                          const TextStyle(fontSize: 15, color: AppColors.heading),
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        suffixIcon: ObscureToggle(
                          obscured: _obscurePassword,
                          onTap: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 48, minHeight: 48),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _RuleHint(satisfied: passwordValid),
                    const SizedBox(height: 12),
                    PasswordStrengthMeter(score: score),
                    const SizedBox(height: 22),

                    const FieldLabel('Re-Enter Password'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmPassword,
                      obscureText: _obscureConfirm,
                      validator: (v) =>
                          Validators.confirmPassword(v, _password.text),
                      style:
                          const TextStyle(fontSize: 15, color: AppColors.heading),
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        suffixIcon: ObscureToggle(
                          obscured: _obscureConfirm,
                          onTap: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    FieldLabel('Create PIN', info: _pinInfo),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _pin,
                      obscureText: _obscurePin,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: Validators.pin,
                      style:
                          const TextStyle(fontSize: 15, color: AppColors.heading),
                      decoration: InputDecoration(
                        hintText: '4-digit PIN',
                        counterText: '',
                        suffixIcon: ObscureToggle(
                          obscured: _obscurePin,
                          onTap: () => setState(() => _obscurePin = !_obscurePin),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    const FieldLabel('Re-Enter PIN'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmPin,
                      obscureText: _obscureConfirmPin,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => Validators.confirmPin(v, _pin.text),
                      style:
                          const TextStyle(fontSize: 15, color: AppColors.heading),
                      decoration: InputDecoration(
                        hintText: 'Re-enter PIN',
                        counterText: '',
                        suffixIcon: ObscureToggle(
                          obscured: _obscureConfirmPin,
                          onTap: () => setState(
                              () => _obscureConfirmPin = !_obscureConfirmPin),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),
                    PrimaryButton(
                      label: 'Complete Registration',
                      onPressed: _complete ? _submit : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleHint extends StatelessWidget {
  const _RuleHint({required this.satisfied});

  final bool satisfied;

  @override
  Widget build(BuildContext context) {
    final color = satisfied ? AppColors.success : AppColors.error;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          satisfied ? Icons.check_circle : Icons.error,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            Validators.passwordRule,
            style: TextStyle(color: color, fontSize: 11.5, height: 1.35),
          ),
        ),
      ],
    );
  }
}
