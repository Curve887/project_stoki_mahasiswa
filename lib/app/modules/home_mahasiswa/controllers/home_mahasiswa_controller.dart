import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class HomeMahasiswaController extends GetxController {
  final barangList = <Map<String, dynamic>>[].obs;
  final currentMahasiswa = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    fetchBarang();
    loadMahasiswa(); // <--- Tambahkan ini!
  }

  Future<void> fetchBarang() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('barang')
          .get();

      final data = snapshot.docs.map((doc) {
        final barang = doc.data();
        barang['id_barang'] = doc.id;
        return barang;
      }).toList();

      barangList.assignAll(data);
    } catch (e) {
      print('Error fetching barang: $e');
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/json/succes.json',
                width: 150,
                repeat: false,
              ),
              const SizedBox(height: 16),
              const Text(
                "Berhasil Meminjam",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Get.back(), // Tutup dialog
                child: const Text("Tutup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pinjamBarang(BuildContext context, Map<String, dynamic> barang) {
    final mahasiswa = currentMahasiswa.value;
    final keteranganController = TextEditingController();
    final jumlahController = TextEditingController();
    String? selectedAdminId;
    String? selectedAdminName;

    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('admin').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final adminList = snapshot.data?.docs ?? [];

            return AlertDialog(
              title: const Text("Form Peminjaman"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Barang: ${barang['nama_barang']}"),
                    const SizedBox(height: 8),
                    Text("Nama: ${mahasiswa['nama']}"),
                    Text("Email: ${mahasiswa['email']}"),
                    Text("NIM: ${mahasiswa['nim']}"),
                    Text("Prodi: ${mahasiswa['prodi'] ?? '-'}"),
                    const SizedBox(height: 12),
                    TextField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Jumlah Pinjam',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Mengetahui (Admin):"),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: adminList.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(data['nama'] ?? 'Tanpa Nama'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedAdminId = value;
                        final selected = adminList.firstWhere(
                          (doc) => doc.id == value,
                          orElse: () => adminList.first,
                        );
                        selectedAdminName =
                            (selected.data() as Map<String, dynamic>)['nama'];
                      },
                      hint: const Text("Pilih Admin"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: keteranganController,
                      decoration: InputDecoration(
                        labelText: 'Keterangan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                      Get.snackbar("Gagal", "Jumlah & Admin wajib diisi");
                      return;
                    }

                    final jumlah =
                        int.tryParse(jumlahController.text.trim()) ?? 0;
                    if (jumlah <= 0 || jumlah > (barang['stok'] ?? 0)) {
                      Get.snackbar("Gagal", "Jumlah tidak valid");
                      return;
                    }

                    final adminDoc = await FirebaseFirestore.instance
                        .collection('admin')
                        .doc(selectedAdminId)
                        .get();

                    final adminData = adminDoc.data();
                    final adminNama = adminData?['nama'] ?? '-';

                    final minjamId = FirebaseFirestore.instance
                        .collection('minjam')
                        .doc()
                        .id;

                    await FirebaseFirestore.instance
                        .collection('minjam')
                        .doc(minjamId)
                        .set({
                          'id_minjam': minjamId,
                          'id_barang': barang['id_barang'],
                          'nama_barang': barang['nama_barang'],
                          'id_mahasiswa': mahasiswa['id_mahasiswa'],
                          'nama': mahasiswa['nama'],
                          'email': mahasiswa['email'],
                          'nim': mahasiswa['nim'],
                          'prodi': mahasiswa['prodi'] ?? '-',
                          'jumlah': jumlah,
                          'tanggal_pinjam': now,
                          'status': 'pending',
                          'keterangan': keteranganController.text.trim(),
                          'id_admin': selectedAdminId,
                          'admin_nama': adminNama,
                          'lokasi_penyimpanan':
                              barang['lokasi_penyimpanan'] ?? '-',
                        });

                    Get.back();
                    showSuccessDialog();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void loadMahasiswa() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('mahasiswa')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id_mahasiswa'] = doc.id; // ✅ Simpan id_mahasiswa juga
        currentMahasiswa.value = data;
      }
    }
  }
}
