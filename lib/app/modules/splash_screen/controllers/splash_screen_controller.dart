
import 'package:get/get.dart';
import 'package:stoksi_ta_mahasiswa/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('SplashScreenController initialized');
    Future.delayed(const Duration(seconds: 3), () {
      print('Navigating to login screen...');
      Get.offAllNamed(Routes.LOGIN_MAHASISWA);
    });
  }
}
