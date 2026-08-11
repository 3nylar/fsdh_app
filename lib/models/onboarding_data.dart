enum Gender { male, female }

enum UploadStatus { idle, uploading, done, failed }

/// One of the three document slots on the upload screen.
class UploadSlot {
  UploadSlot({required this.label, required this.helperText, this.required = false});

  final String label;
  final String helperText;
  final bool required;

  UploadStatus status = UploadStatus.idle;
  double progress = 0;
  String? localPath;
  String? errorMessage;

  bool get isDone => status == UploadStatus.done;
  void reset() {
    status = UploadStatus.idle;
    progress = 0;
    localPath = null;
    errorMessage = null;
  }
}

/// Everything collected across the onboarding flow. Held by
/// [OnboardingController] and submitted at the end.
class OnboardingData {
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';
  Gender? gender;
  DateTime? dateOfBirth;
  String referralCode = '';

  String password = '';
  String pin = '';

  String bvn = '';
  bool bvnSkipped = false;
  bool emailConfirmed = false;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'gender': gender?.name,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'referralCode': referralCode.isEmpty ? null : referralCode,
        'bvn': bvn.isEmpty ? null : bvn,
        // Password and PIN are deliberately omitted — they go to the
        // auth endpoint separately, never into a profile payload.
      };
}
