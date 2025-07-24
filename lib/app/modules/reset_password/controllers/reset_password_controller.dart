import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordController extends GetxController {
  final emailController = ''.obs;

  Future<void> resetPassword() async {
    final email = emailController.value.trim();

    if (email.isEmpty) {
      Get.snackbar('Error', 'Email tidak boleh kosong');
      return;
    }

    try {
      // Cek apakah email terdaftar di koleksi mahasiswa
      final mahasiswaSnapshot = await FirebaseFirestore.instance
          .collection('mahasiswa')
          .where('email', isEqualTo: email)
          .get();

      if (mahasiswaSnapshot.docs.isEmpty) {
        Get.snackbar('Gagal', 'Email tidak ditemukan dalam data mahasiswa');
        return;
      }

      // Kirim email reset password lewat Firebase Auth
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Tampilkan animasi sukses
      showSuccessAnimation();
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void showSuccessAnimation() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/json/email.json', height: 150),
            const SizedBox(height: 16),
            const Text(
              'Link reset password telah dikirim ke email!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // tutup dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
