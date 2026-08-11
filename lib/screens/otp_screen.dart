import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/onboarding_controller.dart';
import '../theme/app_colors.dart';

const int _otpLength = 6;
const int _resendSeconds = 45;

/// Full-screen navy OTP entry with its own keypad, so the OS keyboard
/// never covers the digits.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';
  String? _error;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _press(String digit) {
    if (_code.length >= _otpLength) return;
    setState(() {
      _code += digit;
      _error = null;
    });
    if (_code.length == _otpLength) _verify();
  }

  void _backspace() {
    if (_code.isEmpty) return;
    setState(() {
      _code = _code.substring(0, _code.length - 1);
      _error = null;
    });
  }

  Future<void> _verify() async {
    final controller = context.read<OnboardingController>();
    final ok = await controller.verifyOtp(_code);
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = controller.error ?? 'That code is incorrect.';
        _code = '';
      });
    }
  }

  Future<void> _resend() async {
    await context.read<OnboardingController>().resendOtp();
    if (!mounted) return;
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A new code has been sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(false),
                tooltip: 'Close',
              ),
              const SizedBox(height: 24),

              const Text(
                'Authenticate your BVN to proceed',
                style: TextStyle(color: Color(0xFFB9CFE2), fontSize: 15),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Enter the OTP code sent to the number ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: controller.maskedPhone,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              _CodeBoxes(code: _code, length: _otpLength),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(
                      color: Color(0xFFFFB4B8), fontSize: 13),
                ),
              ],

              if (controller.busy) ...[
                const SizedBox(height: 20),
                const Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ],

              const Spacer(),
              _Keypad(onDigit: _press, onBackspace: _backspace),
              const SizedBox(height: 18),

              Center(
                child: TextButton(
                  onPressed: _secondsLeft == 0 ? _resend : null,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E96),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFFB9CFE2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _secondsLeft == 0
                        ? 'Resend OTP'
                        : 'Resend OTP in ${_secondsLeft}s',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Six underscores that fill with digits as they're typed.
class _CodeBoxes extends StatelessWidget {
  const _CodeBoxes({required this.code, required this.length});

  final String code;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (i) {
        final filled = i < code.length;
        return SizedBox(
          width: 38,
          child: Column(
            children: [
              SizedBox(
                height: 28,
                child: filled
                    ? Text(
                        code[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              Container(height: 2, color: Colors.white),
            ],
          ),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onDigit, required this.onBackspace});

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'back'],
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          children: row.map((key) {
            if (key.isEmpty) return const Expanded(child: SizedBox(height: 70));
            if (key == 'back') {
              return Expanded(
                child: InkWell(
                  onTap: onBackspace,
                  child: const SizedBox(
                    height: 70,
                    child: Icon(Icons.backspace_outlined,
                        color: Colors.white, size: 24),
                  ),
                ),
              );
            }
            return Expanded(
              child: InkWell(
                onTap: () => onDigit(key),
                child: SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
