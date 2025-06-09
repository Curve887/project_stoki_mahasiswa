import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginMahasiswaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
        final uid = userCredential.user!.uid;

        // Ambil data mahasiswa dari Firestore
        final doc = await _firestore.collection('mahasiswa').doc(uid).get();
        if (doc.exists) {
          final mahasiswaData = doc.data();
          // Pastikan field status sudah ada saat registrasi, misalnya 'pending' atau 'approved'
          final status = mahasiswaData?['status'] ?? 'pending';
          if (status != 'approved') {
            Get.snackbar(
              "Akun Belum Disetujui",
              "Akun Anda belum disetujui oleh admin.",
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            // Logout untuk menghindari state aneh
            await _auth.signOut();
            return;
          }

          Get.snackbar("Sukses", "Berhasil login sebagai mahasiswa");

          // Navigasi langsung ke halaman berikutnya tanpa delay
          Get.offAllNamed('/navbar-mahasiswa');
        } else {
          Get.snackbar("Gagal", "Data mahasiswa tidak ditemukan di database");
        }
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Login Gagal", e.message ?? "Terjadi kesalahan");
      }
    }
  }
}
