import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/onboarding_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/common.dart';
import 'email_confirmation_screen.dart';
import 'otp_screen.dart';

class AddBvnScreen extends StatefulWidget {
  const AddBvnScreen({super.key});

  @override
  State<AddBvnScreen> createState() => _AddBvnScreenState();
}

class _AddBvnScreenState extends State<AddBvnScreen> {
  final _bvn = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _bvn.dispose();
    super.dispose();
  }

  bool get _valid => Validators.bvn(_bvn.text) == null;

  Future<void> _submit() async {
    final controller = context.read<OnboardingController>();
    setState(() => _error = Validators.bvn(_bvn.text));
    if (_error != null) return;

    final ok = await controller.submitBvn(_bvn.text);
    if (!mounted) return;

    if (!ok) {
      setState(() => _error = controller.error ?? 'Could not verify that BVN.');
      return;
    }

    final verified = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const OtpScreen()),
    );
    if (!mounted) return;

    // Only advance once the OTP actually came back verified; dismissing
    // the sheet leaves the user here to try again.
    if (verified == true) _goToEmailStep();
  }

  void _skip() {
    context.read<OnboardingController>().skipBvn();
    _goToEmailStep();
  }

  void _goToEmailStep() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EmailConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<OnboardingController>().busy;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Add BVN',
          style: TextStyle(
            color: AppColors.heading,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: busy ? null : _skip,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.tooltip,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Skip Step',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 26),

              const FieldLabel('Bank Verification Number(11- digits)'),
              const SizedBox(height: 6),
              TextField(
                controller: _bvn,
                keyboardType: TextInputType.number,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() => _error = null),
                style:
                    const TextStyle(fontSize: 15, color: AppColors.heading),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '',
                  errorText: _error,
                ),
              ),
              const SizedBox(height: 18),

              // Navy explainer banner.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                decoration: BoxDecoration(
                  color: AppColors.banner,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.white,
                      child: Text(
                        'i',
                        style: TextStyle(
                          color: AppColors.banner,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'We need your Bank Verification Number (BVN) to '
                        'confirm who you are.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              PrimaryButton(
                label: 'Submit',
                busy: busy,
                onPressed: _valid ? _submit : null,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
