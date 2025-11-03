import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petrolpumpdispensing/utils/app_color.dart';
import 'package:petrolpumpdispensing/widget/app_text.dart';
import 'package:sizer/sizer.dart';
import '../../../widget/dot_wave_loading.dart';
import '../controller/auth_controller.dart';
import '../../../helper/email_validation.dart';
import '../../../utils/app_string.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    final size=MediaQuery.of(context).size;
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: size.width * 0.9,
              padding:  EdgeInsets.symmetric(horizontal: 16.sp,vertical: 16.sp),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(19.sp)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                     SizedBox(height: size.height * 0.02),
                    Obx(() => AppText(text:
                          controller.isSignUpMode.value ? AppString.signUp : AppString.signIn,
                          textAlign: TextAlign.center,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                        )),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppString.email,
                        hintText: AppString.enterYourEmail,
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                      ),
                      validator: EmailValidation.validateEmail,
                      onChanged: (value) => controller.emailController.value = value,
                    ),
                    SizedBox(height: size.height * 0.025),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppString.password,
                        hintText: AppString.enterYourPassword,
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppString.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return AppString.passwordMinLength;
                        }
                        return null;
                      },
                      onChanged: (value) => controller.passwordController.value = value,
                    ),
                    Obx(() => controller.isSignUpMode.value
                        ? Column(
                            children: [
                              SizedBox(height: size.height * 0.025),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: AppString.confirmPassword,
                                  hintText: AppString.confirmYourPassword,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),

                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),

                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppString.pleaseConfirmPassword;
                                  }
                                  if (value != controller.passwordController.value) {
                                    return AppString.passwordsDoesNotMatch;
                                  }
                                  return null;
                                },
                                onChanged: (value) => controller.confirmPasswordController.value = value,
                              ),
                            ],
                          )
                        : const SizedBox()),
                    SizedBox(height: size.height * 0.03),
                    Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (controller.isSignUpMode.value) {
                                      controller.signUp();
                                    } else {
                                      controller.signIn();
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.isLoading.value
                              ?  SizedBox(
                              height: size.height * 0.03,
                                  child: WaveDots()
                                )
                              : AppText(text:
                                  controller.isSignUpMode.value ? AppString.signUp : AppString.signIn,
                              fontSize: 16,
                            color: AppColors.white,
                                ),
                        )),
                    const SizedBox(height: 20),
                    Obx(() => TextButton(
                          onPressed: controller.isLoading.value ? null : controller.toggleMode,
                          child: AppText(
                            text:
                            controller.isSignUpMode.value
                                ? AppString.alreadyHaveAccount
                                : AppString.dontHaveAccount,
                              color: AppColors.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

