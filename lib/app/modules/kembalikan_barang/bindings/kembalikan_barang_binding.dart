import 'package:get/get.dart';

import '../controllers/kembalikan_barang_controller.dart';

class KembalikanBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KembalikanBarangController>(
      () => KembalikanBarangController(),
    );
  }
}
