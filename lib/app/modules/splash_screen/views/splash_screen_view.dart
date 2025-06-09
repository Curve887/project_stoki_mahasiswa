import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController()); // Ensure controller is initialized
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Image.asset(
          'assets/image/splashscreen.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
