import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 

class PinjamBarangController extends GetxController {
  final storage = const FlutterSecureStorage();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var dataPeminjaman = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPeminjamanMahasiswa();
  }

  Future<void> fetchPeminjamanMahasiswa() async {
    try {
      final uid = await storage.read(key: 'uid');
      if (uid == null) return;

      // Inisialisasi lokal Bahasa Indonesia untuk format tanggal
      await initializeDateFormatting('id_ID', null); 

      final snapshot = await firestore
          .collection('minjam')
          .where('id_mahasiswa', isEqualTo: uid)
          .get();

      List<Map<String, dynamic>> hasil = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();

        // Ambil data admin dan mahasiswa
        var adminRef = await firestore
            .collection('admin')
            .doc(data['id_admin'])
            .get();

        var mahasiswaRef = await firestore
            .collection('mahasiswa')
            .doc(data['id_mahasiswa'])
            .get();

        // Konversi tanggal_pinjam
        DateTime? tanggal;
        String tanggalFormat = '-';

        if (data['tanggal_pinjam'] is Timestamp) {
          tanggal = (data['tanggal_pinjam'] as Timestamp).toDate();
          tanggalFormat = DateFormat(
            "dd MMMM yyyy, HH:mm",
            "id_ID",
          ).format(tanggal);
        } else if (data['tanggal_pinjam'] is String) {
          tanggal = DateTime.tryParse(data['tanggal_pinjam']);
          if (tanggal != null) {
            tanggalFormat = DateFormat(
              "dd MMMM yyyy, HH:mm",
              "id_ID",
            ).format(tanggal);
          }
        }

        hasil.add({
          'nama_barang': data['nama_barang'] ?? 'Tidak ditemukan',
          'jumlah': data['jumlah'] ?? 0,
          'status': data['status'] ?? '-',
          'nama_admin': adminRef.data()?['nama'] ?? 'Tidak ditemukan',
          'nim': mahasiswaRef.data()?['nim'] ?? '-',
          'prodi': mahasiswaRef.data()?['prodi'] ?? '-',
          'tanggal': tanggal,
          'tanggal_format': tanggalFormat,
        });
      }

      dataPeminjaman.value = hasil;
    } catch (e) {
      print('Gagal mengambil data peminjaman: $e');
    }
  }
}
