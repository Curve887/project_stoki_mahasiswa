import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stoksi_ta_mahasiswa/app/data/status/status.dart';
import '../controllers/kembalikan_barang_controller.dart';

class KembalikanBarangView extends GetView<KembalikanBarangController> {
  const KembalikanBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KembalikanBarangController());

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengembalian Saya')),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            controller.ambilDataPengembalian();
          },
          child: controller.dataPengembalian.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 100),
                    Center(child: Text("Belum ada barang yang dikembalikan.")),
                  ],
                )
              : ListView.builder(
                  itemCount: controller.dataPengembalian.length,
                  itemBuilder: (context, index) {
                    final item = controller.dataPengembalian[index];
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shadowColor: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
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
                            Text('Nama: ${item['nama_mahasiswa'] ?? '-'}'),
                            Text('Jumlah: ${item['jumlah']}'),
                            Text('NIM: ${item['nim']}'),
                            Text('Prodi: ${item['prodi']}'),
                            Text('Admin: ${item['nama_admin'] ?? '-'}'),
                            Text(
                              'Tanggal Pengembalian: ${item['tanggal_pengembalian_format'] ?? '-'}',
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${item['status'] ?? '-'}',
                              style: TextStyle(
                                color: getStatusColor(item['status'] ?? ''),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
