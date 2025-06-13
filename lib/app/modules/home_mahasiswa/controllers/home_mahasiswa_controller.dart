import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeMahasiswaController extends GetxController {
  final barangList = <Map<String, dynamic>>[].obs;
  final currentMahasiswa = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    fetchBarang();
    loadMahasiswa(); // <--- Tambahkan ini!
  }

  void fetchBarang() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('barang')
          .get();

      final data = snapshot.docs.map((doc) {
        final barang = doc.data();
        barang['id_barang'] =
            doc.id; // ✅ Tambahkan ID dokumen sebagai id_barang
        return barang;
      }).toList();

      barangList.assignAll(data);
    } catch (e) {
      print('Error fetching barang: $e');
    }
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
