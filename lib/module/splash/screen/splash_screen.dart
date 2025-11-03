import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petrolpumpdispensing/utils/app_color.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child:Image.asset("assets/logo.png")
      ),
    );
  }
}

