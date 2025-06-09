import 'package:get/get.dart';
import 'package:stoksi_ta_mahasiswa/app/modules/profil_mahasiswa/controllers/profil_mahasiswa_controller.dart';
import 'package:stoksi_ta_mahasiswa/app/modules/search_barang/controllers/search_barang_controller.dart';

import '../controllers/navbar_mahasiswa_controller.dart';

class NavbarMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarMahasiswaController>(() => NavbarMahasiswaController());
    Get.lazyPut<SearchBarangController>(() => SearchBarangController());
    Get.lazyPut<ProfilMahasiswaController>(() => ProfilMahasiswaController());
  }
}
