import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';
import '../utils/status_strings.dart';

class AppSnackBar {
  static Future<void> showSnackBar({
    required String message,
    required String title,
    Color? backgroundColor,
    Color? textColor,
    bool? isFromHomeOrSharePost,
  }) async {
    Get.closeAllSnackbars();

    await Future.delayed(const Duration(milliseconds: 200));
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderRadius: 8,
      backgroundColor: backgroundColor ?? AppColors.closeRed,
      animationDuration: const Duration(milliseconds: 500),
      barBlur: 10,
      duration: const Duration(seconds: 2),
      colorText: textColor ?? AppColors.white,
      isDismissible: true,
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? AppColors.white,
        ),
      ),
    );
  }

  static Future<void> noInterNetSnackBar() async {
    Get.closeAllSnackbars();
    await Future.delayed(const Duration(milliseconds: 200));
    Get.snackbar(
      StatusStrings.internet,
      StatusStrings.checkYourInternetConnection,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderRadius: 8,
      backgroundColor: AppColors.closeRed,
      animationDuration: const Duration(milliseconds: 500),
      barBlur: 10,
      duration: const Duration(seconds: 2),
      colorText: AppColors.white,
      isDismissible: true,
    );
  }

  static Future<void> serverErrorSnackBar() async {
    Get.closeAllSnackbars();
    await Future.delayed(const Duration(milliseconds: 200));
    Get.snackbar(
      StatusStrings.error,
      StatusStrings.serverError,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      borderRadius: 8,
      backgroundColor: AppColors.closeRed,
      animationDuration: const Duration(milliseconds: 500),
      barBlur: 10,
      duration: const Duration(seconds: 2),
      colorText: AppColors.white,
      isDismissible: true,
    );
  }
}
