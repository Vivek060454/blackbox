import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/app_color.dart';
import '../service/auth_service.dart';
import '../../../helper/email_validation.dart';
import '../../../helper/snach_bar.dart';
import '../../../helper/check_internet_connection.dart';
import '../../../utils/app_string.dart';
import '../../../utils/status_strings.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final isLoading = false.obs;
  final isSignUpMode = false.obs;

  final emailController = ''.obs;
  final passwordController = ''.obs;
  final confirmPasswordController = ''.obs;

  void toggleMode() {
    isSignUpMode.value = !isSignUpMode.value;
    clearFields();
  }

  void clearFields() {
    emailController.value = '';
    passwordController.value = '';
    confirmPasswordController.value = '';
  }

  ///sign up
  Future<void> signUp() async {
    if (!await CheckInternetConnection().internetAvailable()) {
      AppSnackBar.noInterNetSnackBar();
      return;
    }
    final email = emailController.value.trim();
    final password = passwordController.value.trim();
    final confirmPassword = confirmPasswordController.value.trim();
    final emailError = EmailValidation.validateEmail(email);

    if (emailError != null) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: emailError);
      return;
    }
    if (password.isEmpty || password.length < 6) {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: AppString.passwordMinimumLength,
      );
      return;
    }
    if (password != confirmPassword) {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: AppString.passwordsDoesNotMatch,
      );
      return;
    }
    isLoading.value = true;
    try {
      await _authService.signUp(email: email, password: password);
      AppSnackBar.showSnackBar(
        title: StatusStrings.success,
        message: AppString.accountCreatedSuccessfully,
        backgroundColor: AppColors.successGreen,
      );
      Get.offAllNamed('/listing');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = AppString.noUserFoundForEmail;
          break;
        case 'wrong-password':
          message = AppString.wrongPasswordProvided;
          break;
        case 'invalid-email':
          message = AppString.emailAddressNotValid;
          break;
        default:
          message = StatusStrings.somethingWentWrong;
      }
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: message);
    } catch (e) {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: StatusStrings.somethingWentWrong,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn() async {
    if (!await CheckInternetConnection().internetAvailable()) {
      AppSnackBar.noInterNetSnackBar();
      return;
    }

    final email = emailController.value.trim();
    final password = passwordController.value.trim();

    final emailError = EmailValidation.validateEmail(email);
    if (emailError != null) {
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: emailError);
      return;
    }

    if (password.isEmpty) {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: AppString.pleaseEnterPassword,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _authService.signIn(email: email, password: password);
      Get.offAllNamed('/listing');
    } on FirebaseAuthException catch (e) {
      String message = e.code == 'user-not-found'
          ? AppString.noUserFoundForEmailShort
          : e.code == 'wrong-password'
          ? AppString.wrongPasswordProvidedShort
          : StatusStrings.somethingWentWrong;
      AppSnackBar.showSnackBar(title: StatusStrings.error, message: message);
    } catch (e) {
      AppSnackBar.showSnackBar(
        title: StatusStrings.error,
        message: StatusStrings.somethingWentWrong,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
