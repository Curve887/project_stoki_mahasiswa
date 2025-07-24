import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class KembalikanBarangController extends GetxController {
  final dataPengembalian = [].obs;
  final isLoading = true.obs;
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting('id_ID', null).then((_) {
      ambilDataPengembalian();
    });
  }

  void ambilDataPengembalian() async {
    isLoading.value = true;
    try {
      final uid = await _storage.read(key: 'uid');
      if (uid == null) {
        Get.snackbar("Error", "User ID tidak ditemukan.");
        isLoading.value = false;
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('pengembalian')
          .where('id_mahasiswa', isEqualTo: uid)
          .get();

      List<Map<String, dynamic>> hasil = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();

        var mahasiswaDoc = await FirebaseFirestore.instance
            .collection('mahasiswa')
            .doc(data['id_mahasiswa'])
            .get();
        var namaMahasiswa = mahasiswaDoc.data()?['nama'] ?? 'Tidak diketahui';

        String? namaAdmin;
        if (data['id_admin'] != null) {
          var adminDoc = await FirebaseFirestore.instance
              .collection('admin')
              .doc(data['id_admin'])
              .get();
          namaAdmin = adminDoc.data()?['nama'] ?? 'Tidak diketahui';
        }

        final timestamp = data['tanggal_pengembalian'] as Timestamp?;
        final tanggalPengembalian = timestamp != null
            ? DateFormat(
                'd MMMM yyyy • HH:mm',
                'id_ID',
              ).format(timestamp.toDate())
            : 'Tidak diketahui';

        hasil.add({
          ...data,
          'nama_mahasiswa': namaMahasiswa,
          'nama_admin': namaAdmin,
          'tanggal_pengembalian_format': tanggalPengembalian,
        });
      }

      dataPengembalian.value = hasil;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pengembalian: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
