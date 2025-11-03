import 'package:get_storage/get_storage.dart';

class AppSharedPreference {
  static final _getStorage = GetStorage();

  static const String _email = 'email';
  static const String _isLoggedIn = 'is_logged_in';



  /// Email
  static Future<void> setEmail(String email) async => await _getStorage.write(_email, email);
  static String? get email => _getStorage.read(_email);

  /// Login State
  static Future<void> setLoggedIn(bool value) async => await _getStorage.write(_isLoggedIn, value);
  static bool get isLoggedIn => _getStorage.read(_isLoggedIn) ?? false;

  /// Clear all data
  static void clear() => _getStorage.erase();

}
