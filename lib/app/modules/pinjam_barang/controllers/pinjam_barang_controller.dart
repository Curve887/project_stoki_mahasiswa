import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PinjamBarangController extends GetxController {
  final storage = const FlutterSecureStorage();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var dataPeminjaman = [].obs;
  var daftarAdmin = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPeminjamanMahasiswa();
    fetchDaftarAdmin(); // ini ditambahkan
  }

  Future<void> fetchPeminjamanMahasiswa() async {
    try {
      final uid = await storage.read(key: 'uid');
      if (uid == null) return;

      await initializeDateFormatting('id_ID', null);

      final snapshot = await firestore
          .collection('minjam')
          .where('id_mahasiswa', isEqualTo: uid)
          .where(
            'status',
            whereIn: ['approved', 'pending'],
          ) // tampilkan dua status
          .get();

      List<Map<String, dynamic>> hasil = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();

        var adminRef = await firestore
            .collection('admin')
            .doc(data['id_admin'])
            .get();

        var mahasiswaRef = await firestore
            .collection('mahasiswa')
            .doc(data['id_mahasiswa'])
            .get();

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
          'doc_id': doc.id,
          'nama_barang': data['nama_barang'] ?? 'Tidak ditemukan',
          'jumlah': data['jumlah'] ?? 0,
          'status': data['status'] ?? '-',
          'nama_admin': adminRef.data()?['nama'] ?? 'Tidak ditemukan',
          'id_admin': data['id_admin'] ?? '',
          'nim': mahasiswaRef.data()?['nim'] ?? '-',
          'prodi': mahasiswaRef.data()?['prodi'] ?? '-',
          'nama_mahasiswa': mahasiswaRef.data()?['nama'] ?? 'Tidak ditemukan',
          'tanggal': tanggal,
          'tanggal_format': tanggalFormat,
          'lokasi_penyimpanan':
              data['lokasi_penyimpanan'] ?? '-', 
        });
      }

      dataPeminjaman.value = hasil;
    } catch (e) {
      print('Gagal mengambil data peminjaman: $e');
    }
  }

  Future<void> fetchDaftarAdmin() async {
    try {
      final snapshot = await firestore.collection('admin').get();
      daftarAdmin.value = snapshot.docs.map((doc) {
        return {'id': doc.id, 'nama': doc['nama']};
      }).toList();
    } catch (e) {
      print('Gagal mengambil data admin: $e');
    }
  }

  Future<void> kembalikanBarang(Map<String, dynamic> item) async {
    try {
      final uid = await storage.read(key: 'uid');
      if (uid == null) return;

      // Tambahkan ke koleksi pengembalian
      await firestore.collection('pengembalian').add({
        'id_mahasiswa': uid,
        'id_admin': item['id_admin'] ?? '',
        'nama_barang': item['nama_barang'],
        'jumlah': item['jumlah'],
        'nama_admin': item['nama_admin'],
        'nim': item['nim'],
        'prodi': item['prodi'],
        'tanggal_pengembalian': Timestamp.now(),
        'status': 'pending',
      });

      // Ubah status di koleksi minjam
      if (item['doc_id'] != null) {
        await firestore.collection('minjam').doc(item['doc_id']).update({
          'status': 'returned',
        });
      }

      print("Barang berhasil dikembalikan dan status diupdate.");
    } catch (e) {
      print("Gagal mengembalikan barang: $e");
      Get.snackbar("Error", "Gagal mengembalikan barang.");
    }
  }
}
