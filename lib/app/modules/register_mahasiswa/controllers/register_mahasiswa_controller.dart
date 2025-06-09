import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterMahasiswaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final prodiController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void register() async {
    if (!formKey.currentState!.validate()) return;

    // Tampilkan loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 1. Buat akun Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // 2. Simpan data mahasiswa ke Firestore
      await _firestore
          .collection("mahasiswa")
          .doc(userCredential.user!.uid)
          .set({
            "uid": userCredential.user!.uid,
            "email": emailController.text.trim(),
            "nama": namaController.text.trim(),
            "nim": nimController.text.trim(),
            "prodi": prodiController.text.trim(),
            "status": "pending", // Status awal: pending approval
            "createdAt": FieldValue.serverTimestamp(),
          });

      // Pastikan dialog loading ditutup sebelum navigasi
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        "Berhasil",
        "Akun sudah di buat, Silahkan hubungi/tunggu admin Untuk Aktivasi Akun.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigasi langsung ke halaman login tanpa delay
      Get.offAllNamed('/login-mahasiswa');
    } on FirebaseAuthException catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      String errorMsg = "Terjadi kesalahan";
      if (e.code == 'email-already-in-use') {
        errorMsg = "Email sudah terdaftar. Silakan login.";
      } else if (e.code == 'weak-password') {
        errorMsg = "Password terlalu lemah (minimal 6 karakter).";
      } else if (e.code == 'invalid-email') {
        errorMsg = "Format email tidak valid.";
      } else {
        errorMsg = e.message ?? errorMsg;
      }

      Get.snackbar(
        "Gagal",
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    namaController.dispose();
    nimController.dispose();
    prodiController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
