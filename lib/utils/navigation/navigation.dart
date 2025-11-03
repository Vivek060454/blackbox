import 'package:get/get.dart';
import '../../module/auth/screen/auth_screen.dart';
import '../../module/petrolPumpList/controller/transaction_controller.dart';
import '../../module/petrolPumpList/screen/entry_details_screen.dart';
import '../../module/petrolPumpList/screen/listing_screen.dart';
import '../../module/splash/screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String listing = '/listing';
  static const String entryDetails = '/entry-details';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      page: () => AuthScreen(),
    ),
    GetPage(
      name: listing,
      page: () => ListingScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<TransactionController>()) {
          Get.put(TransactionController());
        }
      }),
    ),
    GetPage(
      name: entryDetails,
      page: () => EntryDetailsScreen(),
      binding: BindingsBuilder(() {
        // Ensure TransactionController is registered
        if (!Get.isRegistered<TransactionController>()) {
          Get.put(TransactionController());
        }
      }),
    ),
  ];
}
