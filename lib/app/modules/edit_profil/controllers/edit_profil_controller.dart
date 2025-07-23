import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditProfilController extends GetxController {
  final namaController = TextEditingController();
  final prodiController = TextEditingController();
  final nimController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var showNewPassword = false.obs;
  var showConfirmPassword = false.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String userId = '';

  void toggleNewPassword() => showNewPassword.toggle();
  void toggleConfirmPassword() => showConfirmPassword.toggle();

  @override
  void onInit() {
    super.onInit();
    loadUserId();
  }

  void loadUserId() async {
    userId = await storage.read(key: 'uid') ?? '';
    if (userId.isNotEmpty) {
      fetchUserData();
    } else {
      Get.snackbar("Error", "User ID tidak ditemukan");
    }
  }

  void fetchUserData() async {
    try {
      final doc = await firestore.collection('mahasiswa').doc(userId).get();

      if (doc.exists) {
        final data = doc.data()!;
        namaController.text = data['nama'] ?? '';
        prodiController.text = data['prodi'] ?? '';
        nimController.text = data['nim'] ?? '';
      } else {
        Get.snackbar("Error", "Data tidak ditemukan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data: $e");
    }
  }

  void saveProfile() async {
    try {
      // Validasi password baru jika diisi
      if (newPasswordController.text.isNotEmpty ||
          confirmPasswordController.text.isNotEmpty) {
        if (newPasswordController.text != confirmPasswordController.text) {
          Get.snackbar(
            "Gagal",
            "Password baru dan konfirmasi tidak cocok",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }

        // ✅ Update password di FirebaseAuth
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(newPasswordController.text);
        }
      }

      // ✅ Update profil di Firestore
      final updateData = {
        'nama': namaController.text,
        'prodi': prodiController.text,
        'nim': nimController.text,
      };

      await firestore.collection('mahasiswa').doc(userId).update(updateData);

      Get.snackbar(
        "Berhasil",
        "Profil berhasil diperbarui",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan data: $e");
    }
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
