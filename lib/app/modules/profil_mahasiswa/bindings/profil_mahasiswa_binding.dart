import 'package:get/get.dart';

import '../controllers/profil_mahasiswa_controller.dart';

class ProfilMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilMahasiswaController>(
      () => ProfilMahasiswaController(),
    );
  }
}
