import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fsdh_app/screens/login_screen.dart';
import 'package:fsdh_app/screens/welcome_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/onboarding_data.dart';
import '../state/onboarding_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/common.dart';
import 'security_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static const int _minAge = 13;
  static const int _maxAge = 100;

  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _referral = TextEditingController();

  Gender? _gender;
  DateTime? _dob;
  bool _submitted = false;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _phone, _email, _referral]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _complete =>
      _firstName.text.trim().isNotEmpty &&
          _lastName.text.trim().isNotEmpty &&
          _phone.text.trim().isNotEmpty &&
          _email.text.trim().isNotEmpty &&
          _gender != null &&
          _dob != null;

  DateTime get _latestAllowedDob {
    final now = DateTime.now();
    return DateTime(now.year - _minAge, now.month, now.day);
  }

  DateTime get _earliestAllowedDob {
    final now = DateTime.now();
    return DateTime(now.year - _maxAge, now.month, now.day);
  }

  Future<void> _pickDate(FormFieldState<DateTime> field) async {
    final latest = _latestAllowedDob;
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? latest,
      firstDate: _earliestAllowedDob,
      lastDate: latest,
      helpText: 'Select your date of birth',
    );

    // The picker is async — the screen may have been popped while it was open.
    if (!mounted || picked == null) return;

    setState(() => _dob = picked);
    field.didChange(picked);
  }

  void _next() {
    setState(() => _submitted = true);

    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk || _gender == null) return;

    context.read<OnboardingController>().setPersonalDetails(
      firstName: _firstName.text,
      lastName: _lastName.text,
      phone: _phone.text,
      email: _email.text,
      gender: _gender,
      dateOfBirth: _dob,
      referralCode: _referral.text,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SecurityScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    ),
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
                    const ScreenTitle(
                      'Registration',
                      subtitle:
                      'Welcome, please provide us with the following information.',
                    ),
                    const SizedBox(height: 20),

                    LabeledField(
                      label: 'First Name',
                      controller: _firstName,
                      keyboardType: TextInputType.name,
                      validator: (v) => Validators.name(v, 'First name'),
                    ),
                    LabeledField(
                      label: 'Last Name',
                      controller: _lastName,
                      keyboardType: TextInputType.name,
                      validator: (v) => Validators.name(v, 'Last name'),
                    ),
                    LabeledField(
                      label: 'Phone Number',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+ -]')),
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: Validators.phone,
                    ),
                    LabeledField(
                      label: 'Email Address',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),

                    // ---- Gender -------------------------------------------
                    FormField<Gender>(
                      initialValue: _gender,
                      validator: (v) =>
                      v == null ? 'Please select a gender' : null,
                      builder: (field) {
                        void select(Gender g) {
                          setState(() => _gender = g);
                          field.didChange(g);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Gender'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _GenderOption(
                                  label: 'Male',
                                  value: Gender.male,
                                  groupValue: _gender,
                                  onChanged: select,
                                ),
                                const SizedBox(width: 75),
                                _GenderOption(
                                  label: 'Female',
                                  value: Gender.female,
                                  groupValue: _gender,
                                  onChanged: select,
                                ),
                              ],
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  field.errorText!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // ---- Date of birth ------------------------------------
                    FormField<DateTime>(
                      initialValue: _dob,
                      validator: Validators.dateOfBirth,
                      builder: (field) {
                        final value = field.value;
                        final text = value == null
                            ? 'Placeholder'
                            : DateFormat('d MMMM yyyy').format(value);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Date of Birth'),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _pickDate(field),
                              behavior: HitTestBehavior.opaque,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  errorText: field.errorText,
                                  suffixIcon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: value == null
                                        ? AppColors.hint
                                        : AppColors.heading,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    LabeledField(
                      label: 'Referral Code',
                      controller: _referral,
                    ),

                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: 'Next',
                      onPressed: _complete ? _next : null,
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Already have an account yet? ',
                            style: TextStyle(
                                color: AppColors.body, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final Gender value;
  final Gender? groupValue;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = groupValue == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.success : AppColors.hint,
                width: 2,
              ),
            ),
            child: selected
                ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: AppColors.heading),
          ),
        ],
      ),
    );
  }
}