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
      final uid = await _storage.read(key: 'uid');
      if (uid == null) {
        Get.snackbar("Error", "User ID tidak ditemukan.");
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('pengembalian')
          .where('id_mahasiswa', isEqualTo: uid)
          .get();

      List<Map<String, dynamic>> hasil = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();

        // Ambil nama mahasiswa
        var mahasiswaDoc = await FirebaseFirestore.instance
            .collection('mahasiswa')
            .doc(data['id_mahasiswa'])
            .get();
        var namaMahasiswa = mahasiswaDoc.data()?['nama'] ?? 'Tidak diketahui';

        // Ambil nama admin
        String? namaAdmin;
        if (data['id_admin'] != null) {
          var adminDoc = await FirebaseFirestore.instance
              .collection('admin')
              .doc(data['id_admin'])
              .get();
          namaAdmin = adminDoc.data()?['nama'] ?? 'Tidak diketahui';
        }

        hasil.add({
          ...data,
          'nama_mahasiswa': namaMahasiswa,
          'nama_admin': namaAdmin,
        });
      }

      dataPengembalian.value = hasil;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengembalian: $e");
    }
  }
}
