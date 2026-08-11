import 'package:flutter/foundation.dart';

import '../models/onboarding_data.dart';
import '../services/onboarding_api.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({OnboardingApi? api}) : _api = api ?? const OnboardingApi();

  final OnboardingApi _api;
  final OnboardingData data = OnboardingData();

  bool _busy = false;
  String? _error;
  String _maskedPhone = '';

  bool get busy => _busy;
  String? get error => _error;
  String get maskedPhone =>
      _maskedPhone.isEmpty ? OnboardingApi.maskPhone(data.phone) : _maskedPhone;

  // ── Document slots ──────────────────────────────────────
  final List<UploadSlot> slots = [
    UploadSlot(
      label: 'Your Photo',
      helperText: 'Take a clear picture of your face in JPEG file format',
      required: true,
    ),
    UploadSlot(
      label: 'Your Valid ID',
      helperText: 'Take a clear picture of your ID in JPEG file format',
    ),
    UploadSlot(
      label: 'Your Signature',
      helperText: 'Take a clear picture of your signature in JPEG file format',
    ),
  ];

  /// Only the photo is marked required in the mockup (red asterisk), so
  /// that alone gates the Next button.
  bool get uploadsSatisfied =>
      slots.where((s) => s.required).every((s) => s.isDone);

  void _setBusy(bool value) {
    _busy = value;
    if (value) _error = null;
    notifyListeners();
  }

  void _fail(Object e) {
    _busy = false;
    _error = e.toString();
    notifyListeners();
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  // ── Step 1: registration details ────────────────────────
  void setPersonalDetails({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required Gender? gender,
    required DateTime? dateOfBirth,
    required String referralCode,
  }) {
    data
      ..firstName = firstName.trim()
      ..lastName = lastName.trim()
      ..phone = phone.trim()
      ..email = email.trim()
      ..gender = gender
      ..dateOfBirth = dateOfBirth
      ..referralCode = referralCode.trim();
    notifyListeners();
  }

  // ── Step 2: credentials ─────────────────────────────────
  void setCredentials({required String password, required String pin}) {
    data
      ..password = password
      ..pin = pin;
    notifyListeners();
  }

  // ── Step 3: documents ───────────────────────────────────
  Future<void> uploadSlot(int index, String path) async {
    final slot = slots[index];
    slot
      ..status = UploadStatus.uploading
      ..progress = 0
      ..errorMessage = null
      ..localPath = path;
    notifyListeners();

    try {
      await _api.uploadDocument(
        slot.label,
        path,
        onProgress: (p) {
          slot.progress = p;
          notifyListeners();
        },
      );
      slot.status = UploadStatus.done;
    } catch (e) {
      slot
        ..status = UploadStatus.failed
        ..errorMessage = 'Upload failed. Tap to retry.';
    }
    notifyListeners();
  }

  void resetSlot(int index) {
    slots[index].reset();
    notifyListeners();
  }

  // ── Step 4: BVN ─────────────────────────────────────────
  /// Submits the BVN and triggers the OTP. Returns true when the OTP
  /// screen should be shown next.
  Future<bool> submitBvn(String bvn) async {
    _setBusy(true);
    try {
      data
        ..bvn = bvn.trim()
        ..bvnSkipped = false;
      _maskedPhone = await _api.requestBvnOtp(data.bvn, data.phone);
      _setBusy(false);
      return true;
    } catch (e) {
      _fail(e);
      return false;
    }
  }

  /// Skipping BVN skips OTP too — the OTP exists to authenticate the
  /// BVN, so there is nothing to verify without one.
  void skipBvn() {
    data
      ..bvn = ''
      ..bvnSkipped = true;
    notifyListeners();
  }

  Future<bool> verifyOtp(String code) async {
    _setBusy(true);
    try {
      final ok = await _api.verifyOtp(code);
      _busy = false;
      _error = ok ? null : 'That code is incorrect. Please try again.';
      notifyListeners();
      return ok;
    } catch (e) {
      _fail(e);
      return false;
    }
  }

  Future<void> resendOtp() async {
    _setBusy(true);
    try {
      await _api.resendOtp();
      _setBusy(false);
    } catch (e) {
      _fail(e);
    }
  }

  // ── Step 5: email confirmation ──────────────────────────
  Future<void> sendConfirmationEmail() async {
    _setBusy(true);
    try {
      await _api.sendConfirmationEmail(data.email);
      _setBusy(false);
    } catch (e) {
      _fail(e);
    }
  }

  void markEmailConfirmed() {
    data.emailConfirmed = true;
    notifyListeners();
  }

  // ── Final submit ────────────────────────────────────────
  Future<bool> completeRegistration() async {
    _setBusy(true);
    try {
      await _api.register(data);
      _setBusy(false);
      return true;
    } catch (e) {
      _fail(e);
      return false;
    }
  }
}
