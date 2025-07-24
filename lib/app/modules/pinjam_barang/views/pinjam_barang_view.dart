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
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchPeminjamanMahasiswa();
          },
          child: controller.dataPeminjaman.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text("Belum ada data peminjaman.")),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.dataPeminjaman.length,
                  itemBuilder: (context, index) {
                    final item = controller.dataPeminjaman[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
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
                          Text(
                            'Lokasi Penyimpanan: ${item['lokasi_penyimpanan']}',
                          ),
                          Text('Tanggal: ${item['tanggal_format'] ?? '-'}'),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${item['status'] ?? '...'}',
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                          const SizedBox(height: 8),
                          if ((item['status'] ?? '').toLowerCase() ==
                              'approved')
                            ElevatedButton.icon(
                              icon: const Icon(Icons.keyboard_return),
                              label: const Text('Kembalikan Barang'),
                              onPressed: () {
                                String? selectedAdminId;
                                String? selectedAdminName;

                                Get.defaultDialog(
                                  title: "Pilih Admin Mengetahui",
                                  content: Obx(() {
                                    if (controller.daftarAdmin.isEmpty) {
                                      return const CircularProgressIndicator();
                                    }
                                    return DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Pilih Admin',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: controller.daftarAdmin.map((
                                        admin,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: admin['id'],
                                          child: Text(admin['nama']),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedAdminId = value;
                                        selectedAdminName = controller
                                            .daftarAdmin
                                            .firstWhere(
                                              (admin) => admin['id'] == value,
                                            )['nama'];
                                      },
                                    );
                                  }),
                                  textCancel: "Batal",
                                  textConfirm: "Ya",
                                  onConfirm: () async {
                                    if (selectedAdminId == null ||
                                        selectedAdminName == null) {
                                      Get.snackbar(
                                        "Error",
                                        "Silakan pilih admin terlebih dahulu.",
                                      );
                                      return;
                                    }
                                    Get.back();

                                    final itemUpdate =
                                        Map<String, dynamic>.from(item);
                                    itemUpdate['id_admin'] = selectedAdminId!;
                                    itemUpdate['nama_admin'] =
                                        selectedAdminName!;

                                    await controller.kembalikanBarang(
                                      itemUpdate,
                                    );
                                    await controller.fetchPeminjamanMahasiswa();

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
                ),
        );
      }),
    );
  }
}
