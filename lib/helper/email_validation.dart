import '../utils/app_string.dart';

class EmailValidation {
  static final emailRegex = RegExp(
    r'^[a-zA-Z0-9]+([._%+-][a-zA-Z0-9]+)*@[a-zA-Z0-9]+([._%+-][a-zA-Z0-9]+)*\.[a-zA-Z]{2,}$',
  );

  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppString.pleaseEnterYourEmail;
    } else if (!isValidEmail(value)) {
      return AppString.pleaseEnterValidEmail;
    }
    return null;
  }
}

