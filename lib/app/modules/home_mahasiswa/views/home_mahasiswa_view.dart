import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_mahasiswa_controller.dart';

class HomeMahasiswaView extends GetView<HomeMahasiswaController> {
  const HomeMahasiswaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Obx(() {
            final mahasiswa = controller.currentMahasiswa.value;
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/image/person.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome,",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      mahasiswa['nama'] ?? 'Mahasiswa',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),

      body: Obx(() {
        if (controller.barangList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const Text(
              'Daftar Barang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...controller.barangList.map((barang) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Informasi barang
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barang['nama_barang'] ?? 'Tanpa Nama',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Stok: ${barang['stok'] ?? 0}'),
                        Text('Brand: ${barang['brand'] ?? '-'}'),
                        Text('Kategori: ${barang['kategori'] ?? ''}'),
                      ],
                    ),

                    // Tombol meminjam
                    IconButton(
                      icon: const Icon(Icons.back_hand, color: Colors.blue),
                      tooltip: 'Pinjam Barang',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final keteranganController =
                                TextEditingController();
                            final jumlahController = TextEditingController();
                            final mahasiswa = controller.currentMahasiswa.value;
                            String? selectedAdminId;
                            String? selectedAdminName;

                            return FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('admin')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final adminList = snapshot.data?.docs ?? [];

                                return AlertDialog(
                                  title: const Text("Form Peminjaman"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Barang: ${barang['nama_barang']}",
                                        ),
                                        const SizedBox(height: 8),
                                        Text("Nama: ${mahasiswa['nama']}"),
                                        Text("Email: ${mahasiswa['email']}"),
                                        Text("NIM: ${mahasiswa['nim']}"),
                                        Text(
                                          "Prodi: ${mahasiswa['prodi'] ?? '-'}",
                                        ),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: jumlahController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Jumlah Pinjam',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text("Mengetahui (Admin):"),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14,
                                                ),
                                          ),
                                          items: adminList.map((doc) {
                                            final data =
                                                doc.data()
                                                    as Map<String, dynamic>;
                                            return DropdownMenuItem<String>(
                                              value: doc.id,
                                              child: Text(
                                                data['nama'] ?? 'Tanpa Nama',
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            selectedAdminId = value;
                                            final selected = adminList
                                                .firstWhere(
                                                  (doc) => doc.id == value,
                                                  orElse: () => adminList.first,
                                                );
                                            selectedAdminName =
                                                (selected.data()
                                                    as Map<
                                                      String,
                                                      dynamic
                                                    >)['nama'];
                                          },
                                          hint: const Text("Pilih Admin"),
                                        ),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: keteranganController,
                                          decoration: InputDecoration(
                                            labelText: 'Keterangan',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 14,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Batal"),
                                      onPressed: () => Get.back(),
                                    ),
                                    ElevatedButton(
                                      child: const Text("Kirim"),
                                      onPressed: () async {
                                        final now = DateTime.now();

                                        if (jumlahController.text.isEmpty ||
                                            selectedAdminId == null) {
                                          Get.snackbar(
                                            "Gagal",
                                            "Jumlah & Admin wajib diisi",
                                          );
                                          return;
                                        }

                                        final jumlah =
                                            int.tryParse(
                                              jumlahController.text.trim(),
                                            ) ??
                                            0;
                                        if (jumlah <= 0 ||
                                            jumlah > (barang['stok'] ?? 0)) {
                                          Get.snackbar(
                                            "Gagal",
                                            "Jumlah tidak valid",
                                          );
                                          return;
                                        }

                                        final adminDoc = await FirebaseFirestore
                                            .instance
                                            .collection('admin')
                                            .doc(selectedAdminId)
                                            .get();

                                        final adminData = adminDoc.data();
                                        final adminNama =
                                            adminData?['nama'] ?? '-';

                                        final minjamId = FirebaseFirestore
                                            .instance
                                            .collection('minjam')
                                            .doc()
                                            .id;

                                        await FirebaseFirestore.instance
                                            .collection('minjam')
                                            .doc(minjamId)
                                            .set({
                                              'id_minjam': minjamId,
                                              'id_barang': barang['id_barang'],
                                              'nama_barang':
                                                  barang['nama_barang'],
                                              'id_mahasiswa':
                                                  mahasiswa['id_mahasiswa'],
                                              'nama': mahasiswa['nama'],
                                              'email': mahasiswa['email'],
                                              'nim': mahasiswa['nim'],
                                              'prodi':
                                                  mahasiswa['prodi'] ?? '-',
                                              'jumlah': jumlah,
                                              'tanggal_pinjam': now,
                                              'status': 'pending',
                                              'keterangan': keteranganController
                                                  .text
                                                  .trim(),
                                              'id_admin': selectedAdminId,
                                              'admin_nama': adminNama,
                                            });

                                        Get.back();
                                        Get.snackbar(
                                          "Sukses",
                                          "Permintaan peminjaman berhasil dikirim",
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      }),
    );
  }
}
