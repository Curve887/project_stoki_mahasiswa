import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pinjam_barang_controller.dart';

class PinjamBarangView extends GetView<PinjamBarangController> {
  const PinjamBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PinjamBarangController());
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Peminjaman Saya")),
      body: Obx(() {
        if (controller.dataPeminjaman.isEmpty) {
          return const Center(child: Text("Belum ada data peminjaman."));
        }
        return ListView.builder(
          itemCount: controller.dataPeminjaman.length,
          itemBuilder: (context, index) {
            final item = controller.dataPeminjaman[index];
            return Card(
              child: ListTile(
                title: Text(item['nama_barang'] ?? '-'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah: ${item['jumlah']}'),
                    Text('Admin Mengetahui: ${item['nama_admin']}'),
                    Text('NIM: ${item['nim']}'),
                    Text('Prodi: ${item['prodi']}'),
                    Text('Tanggal: ${item['tanggal_format'] ?? '-'}'),
                  ],
                ),
                trailing: Text(item['status'] ?? '...'),
              ),
            );
          },
        );
      }),
    );
  }
}
