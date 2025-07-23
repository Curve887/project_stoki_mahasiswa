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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // arah bayangan (x, y)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['nama_barang'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Jumlah: ${item['jumlah']}'),
                  Text('Admin Mengetahui: ${item['nama_admin']}'),
                  Text('NIM: ${item['nim']}'),
                  Text('Nama Mahasiswa: ${item['nama_mahasiswa']}'),
                  Text('Prodi: ${item['prodi']}'),
                  Text('Tanggal: ${item['tanggal_format'] ?? '-'}'),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${item['status'] ?? '...'}',
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  if ((item['status'] ?? '').toLowerCase() == 'approved')
                    ElevatedButton.icon(
                      icon: const Icon(Icons.keyboard_return),
                      label: const Text('Kembalikan Barang'),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Konfirmasi",
                          middleText:
                              "Apakah Anda yakin ingin mengembalikan barang ini?",
                          textCancel: "Tidak",
                          textConfirm: "Ya",
                          onCancel: () => Get.back(),
                          onConfirm: () async {
                            Get.back();
                            await controller.kembalikanBarang(item);
                            await controller
                                .fetchPeminjamanMahasiswa(); // ini akan refresh data
                            Get.snackbar(
                              "Berhasil",
                              "Barang telah dikembalikan.",
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
