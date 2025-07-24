import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mahasiswa {
  final String? nama;
  final String? prodi;

  Mahasiswa({this.nama, this.prodi});
}

class ProfilMahasiswaController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final _firestore = FirebaseFirestore.instance;

  var mahasiswa = Mahasiswa().obs;

  @override
  void onInit() {
    super.onInit();
    fetchMahasiswaData();
  }

  Future<void> fetchMahasiswaData() async {
    try {
      final uid = await _storage.read(
        key: 'uid',
      ); // sesuai dengan key saat login
      if (uid != null) {
        final doc = await _firestore.collection('mahasiswa').doc(uid).get();
        if (doc.exists) {
          final data = doc.data();
          mahasiswa.value = Mahasiswa(
            nama: data?['nama'] ?? 'Nama tidak ditemukan',
            prodi: data?['prodi'] ?? 'Prodi tidak ditemukan',
          );
        } else {
          Get.snackbar("Error", "Data mahasiswa tidak ditemukan di Firestore");
        }
      } else {
        Get.snackbar("Error", "UID tidak ditemukan di secure storage");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data: $e");
    }
  }

  void logout() async {
    // Tampilkan loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // Proses logout
    await Future.delayed(const Duration(seconds: 1)); // simulasi delay
    await _storage.delete(key: 'uid_mahasiswa');

    // Tutup loading dan arahkan ke login
    Get.back(); // tutup dialog loading
    Get.offAllNamed('/login-mahasiswa');
  }
}
