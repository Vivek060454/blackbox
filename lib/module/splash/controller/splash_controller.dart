import 'package:get/get.dart';
import '../../auth/service/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (_authService.isLoggedIn()) {
      Get.offAllNamed('/listing');
    } else {
      Get.offAllNamed('/login');
    }
  }
}

