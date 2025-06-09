import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profil_mahasiswa_controller.dart';

class ProfilMahasiswaView extends GetView<ProfilMahasiswaController> {
  const ProfilMahasiswaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfilMahasiswaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfilMahasiswaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
