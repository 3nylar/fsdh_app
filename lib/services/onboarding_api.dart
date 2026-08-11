import 'dart:async';
import 'dart:math';

import '../models/onboarding_data.dart';

/// Stand-in for the real backend.
///
/// Every method here fakes latency and returns success. Swap this class
/// for an HTTP client when the endpoints exist — the controller only
/// depends on these five signatures, so nothing else has to change.
class OnboardingApi {
  const OnboardingApi();

  Future<void> register(OnboardingData data) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  /// Returns the masked phone number the OTP was sent to, which the OTP
  /// screen displays back to the user (e.g. 0807*****67).
  Future<String> requestBvnOtp(String bvn, String phone) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return maskPhone(phone);
  }

  Future<bool> verifyOtp(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return code.length == 6; // Accepts any 6 digits until the API is wired up.
  }

  Future<void> resendOtp() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<void> sendConfirmationEmail(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  /// Reports upload progress through [onProgress] so the tile can drive
  /// its bar, then completes.
  Future<void> uploadDocument(
    String slotLabel,
    String path, {
    required void Function(double) onProgress,
  }) async {
    const steps = 12;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(
          Duration(milliseconds: 90 + Random().nextInt(70)));
      onProgress(i / steps);
    }
  }

  /// 0807*****67 — first four and last two visible.
  static String maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7) return phone;
    final head = digits.substring(0, 4);
    final tail = digits.substring(digits.length - 2);
    final stars = '*' * (digits.length - 6);
    return '$head$stars$tail';
  }
}
