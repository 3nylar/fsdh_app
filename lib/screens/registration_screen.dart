import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _referral = TextEditingController();

  Gender? _gender;
  DateTime? _dob;
  String? _dobError;
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      helpText: 'Select your date of birth',
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobError = Validators.dateOfBirth(picked);
      });
    }
  }

  void _next() {
    setState(() {
      _submitted = true;
      _dobError = Validators.dateOfBirth(_dob);
    });

    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk || _dobError != null || _gender == null) return;

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
    final dobText =
        _dob == null ? 'Placeholder' : DateFormat('d MMMM yyyy').format(_dob!);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Form(
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
                    maxLength: 14,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+ -]')),
                    ],
                    validator: Validators.phone,
                  ),
                  LabeledField(
                    label: 'Email Address',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
            
                  const FieldLabel('Gender', dark: true),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _GenderOption(
                        label: 'Male',
                        value: Gender.male,
                        groupValue: _gender,
                        onChanged: (g) => setState(() => _gender = g),
                      ),
                      const SizedBox(width: 28),
                      _GenderOption(
                        label: 'Female',
                        value: Gender.female,
                        groupValue: _gender,
                        onChanged: (g) => setState(() => _gender = g),
                      ),
                    ],
                  ),
                  if (_submitted && _gender == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Please select a gender',
                        style: TextStyle(color: AppColors.error, fontSize: 11.5),
                      ),
                    ),
                  const SizedBox(height: 18),
            
                  const FieldLabel('Date of Birth', dark: true),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        errorText: _dobError,
                        suffixIcon: const Icon(Icons.calendar_today_outlined,
                            size: 20, color: AppColors.primary),
                      ),
                      child: Text(
                        dobText,
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              _dob == null ? AppColors.hint : AppColors.heading,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
            
                  LabeledField(
                    label: 'Referral Code',
                    controller: _referral,
                    // Optional — no validator.
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
                          style: TextStyle(color: AppColors.body, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Log in is not part of this flow')),
                            );
                          },
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
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<Gender>(
            value: value,
            groupValue: groupValue,
            onChanged: (v) => onChanged(v!),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: AppColors.success,
          ),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 15, color: AppColors.heading)),
        ],
      ),
    );
  }
}
