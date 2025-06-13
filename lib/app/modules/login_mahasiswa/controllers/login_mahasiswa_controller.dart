import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginMahasiswaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: 'ade@gmail.com');
  final passwordController = TextEditingController(text: 'Arcalion1');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
        final uid = userCredential.user!.uid;

        final doc = await _firestore.collection('mahasiswa').doc(uid).get();
        if (doc.exists) {
          final mahasiswaData = doc.data();
          final status = mahasiswaData?['status'] ?? 'pending';
          if (status != 'approved') {
            Get.snackbar(
              "Akun Belum Disetujui",
              "Akun Anda belum disetujui oleh admin.",
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            await _auth.signOut();
            isLoading.value = false;
            return;
          }

          Get.snackbar("Sukses", "Berhasil login sebagai mahasiswa");
          Get.offAllNamed('/navbar-mahasiswa');
        } else {
          Get.snackbar("Gagal", "Data mahasiswa tidak ditemukan di database");
        }
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Login Gagal", e.message ?? "Terjadi kesalahan");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
