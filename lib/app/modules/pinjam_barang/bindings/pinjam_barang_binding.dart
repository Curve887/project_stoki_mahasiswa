import 'package:get/get.dart';

import '../controllers/pinjam_barang_controller.dart';

class PinjamBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinjamBarangController>(
      () => PinjamBarangController(),
    );
  }
}
