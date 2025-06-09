import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Barang {
  final String id;
  final String namaBarang;
  final int stok;
  final String brand;
  final String lokasiPenyimpanan;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.stok,
    required this.brand,
    required this.lokasiPenyimpanan,
  });

  factory Barang.fromMap(String id, Map<String, dynamic> data) {
    return Barang(
      id: id,
      namaBarang: data['nama_barang'] ?? '',
      stok: data['stok'] ?? 0,
      brand: data['brand'] ?? '',
      lokasiPenyimpanan: data['lokasi_penyimpanan'] ?? '',
    );
  }
}

class SearchBarangController extends GetxController {
  final RxList<Barang> allBarang = <Barang>[].obs;
  var searchQuery = ''.obs;

  List<Barang> get filteredBarang {
    if (searchQuery.value.isEmpty) {
      return allBarang;
    } else {
      return allBarang
          .where(
            (barang) => barang.namaBarang.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void listenToBarangRealtime() {
    FirebaseFirestore.instance.collection('barang').snapshots().listen((
      snapshot,
    ) {
      allBarang.value = snapshot.docs
          .map((doc) => Barang.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenToBarangRealtime();
  }
}
