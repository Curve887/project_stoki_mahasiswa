import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class KembalikanBarangController extends GetxController {
  final dataPengembalian = [].obs;
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    ambilDataPengembalian();
  }

  void ambilDataPengembalian() async {
    try {
      final uid = await _storage.read(key: 'uid'); // pastikan key-nya 'uid'

      if (uid == null) {
        Get.snackbar("Error", "User ID tidak ditemukan.");
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('pengembalian')
          .where('id_mahasiswa', isEqualTo: uid)
          .get();

      dataPengembalian.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengembalian: $e");
    }
  }
}
