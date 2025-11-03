import 'package:get/get.dart';

import '../helper/internet_realtime_connection.dart';
import '../module/auth/controller/auth_controller.dart';
import '../module/splash/controller/splash_controller.dart';

class AppBidding extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkController>(NetworkController());
    Get.put<SplashController>(SplashController());
    Get.put<AuthController>(AuthController());
  }
}
