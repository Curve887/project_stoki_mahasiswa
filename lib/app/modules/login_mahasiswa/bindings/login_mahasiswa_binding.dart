import 'package:get/get.dart';
import 'package:stoksi_ta_mahasiswa/app/modules/home_mahasiswa/controllers/home_mahasiswa_controller.dart';
import 'package:stoksi_ta_mahasiswa/app/modules/register_mahasiswa/controllers/register_mahasiswa_controller.dart';

import '../controllers/login_mahasiswa_controller.dart';

class LoginMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginMahasiswaController>(() => LoginMahasiswaController());
    Get.lazyPut<HomeMahasiswaController>(() => HomeMahasiswaController());
    Get.lazyPut<RegisterMahasiswaController>(
      () => RegisterMahasiswaController(),
    );
  }
}
