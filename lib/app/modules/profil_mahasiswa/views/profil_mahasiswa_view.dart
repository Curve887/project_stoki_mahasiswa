import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_mahasiswa_controller.dart';

class ProfilMahasiswaView extends GetView<ProfilMahasiswaController> {
  const ProfilMahasiswaView({super.key});

  @override
  Widget build(BuildContext context) {
    final mahasiswa = controller.mahasiswa.value;

    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/image/person.png'),
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final mahasiswa = controller.mahasiswa.value;
            return Column(
              children: [
                Text(
                  mahasiswa.nama ?? 'Nama Mahasiswa',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mahasiswa.prodi ?? 'Program Studi',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),

          // Content
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFFDF4F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.green),
                    title: const Text('Edit Profil'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.toNamed('/edit-profil');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Keluar',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah Anda yakin ingin keluar?",
      textCancel: "Tidak",
      textConfirm: "Ya",
      confirmTextColor: Colors.white,
      onConfirm: controller.logout,
    );
  }
}
