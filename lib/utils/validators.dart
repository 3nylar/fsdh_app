/// Form validation shared across the onboarding screens.
class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  static String? required(String? value, String field) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? name(String? value, String field) {
    final err = required(value, field);
    if (err != null) return err;
    if (value!.trim().length < 2) return '$field is too short';
    return null;
  }

  static String? email(String? value) {
    final err = required(value, 'Email address');
    if (err != null) return err;
    if (!_email.hasMatch(value!.trim())) return 'Enter a valid email address';
    return null;
  }

  /// Nigerian mobile numbers: 11 digits local (0803…) or +234 followed
  /// by 10. Strips spaces and dashes before checking.
  static String? phone(String? value) {
    final err = required(value, 'Phone number');
    if (err != null) return err;

    var v = value!.replaceAll(RegExp(r'[\s-]'), '');
    if (v.startsWith('+234')) v = '0${v.substring(4)}';
    if (v.startsWith('234')) v = '0${v.substring(3)}';

    if (!_digitsOnly.hasMatch(v)) return 'Phone number must contain digits only';
    if (v.length != 11) return 'Enter a valid 11-digit phone number';
    return null;
  }

  static String? bvn(String? value) {
    final err = required(value, 'BVN');
    if (err != null) return err;
    final v = value!.trim();
    if (!_digitsOnly.hasMatch(v)) return 'BVN must contain digits only';
    if (v.length != 11) return 'BVN must be exactly 11 digits';
    return null;
  }

  /// The account holder must be at least 18.
  static String? dateOfBirth(DateTime? value) {
    if (value == null) return 'Date of birth is required';
    final now = DateTime.now();
    var age = now.year - value.year;
    final hadBirthday = now.month > value.month ||
        (now.month == value.month && now.day >= value.day);
    if (!hadBirthday) age--;
    if (age < 18) return 'You must be at least 18 years old';
    if (age > 120) return 'Enter a valid date of birth';
    return null;
  }

  // ── Password ────────────────────────────────────────────
  static const String passwordRule =
      'The password requires a minimum of 6 characters, 1 number and a '
      'special character';

  static bool hasMinLength(String v) => v.length >= 6;
  static bool hasNumber(String v) => RegExp(r'\d').hasMatch(v);
  static bool hasSpecial(String v) =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/~`;]').hasMatch(v);
  static bool hasMixedCase(String v) =>
      RegExp(r'[a-z]').hasMatch(v) && RegExp(r'[A-Z]').hasMatch(v);

  /// Whether the password clears the stated minimum. Mixed case is
  /// scored in the meter but not demanded, matching the rule text.
  static bool passwordMeetsRule(String v) =>
      hasMinLength(v) && hasNumber(v) && hasSpecial(v);

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (!passwordMeetsRule(value)) return passwordRule;
    return null;
  }

  /// 0–4, feeding the four-segment strength meter.
  static int passwordScore(String v) {
    if (v.isEmpty) return 0;
    var score = 0;
    if (hasMinLength(v)) score++;
    if (hasNumber(v)) score++;
    if (hasSpecial(v)) score++;
    if (hasMixedCase(v) && v.length >= 10) score++;
    return score;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please re-enter your password';
    if (value != original) return "The password doesn't match";
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'PIN is required';
    if (!_digitsOnly.hasMatch(value)) return 'PIN must be digits only';
    if (value.length != 4) return 'PIN must be 4 digits';
    return null;
  }

  static String? confirmPin(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please re-enter your PIN';
    if (value != original) return "The PIN doesn't match";
    return null;
  }
}
