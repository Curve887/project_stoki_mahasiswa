import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_barang_controller.dart';

class SearchBarangView extends GetView<SearchBarangController> {
  const SearchBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang luar putih
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[800], // AppBar tetap abu-abu gelap
        title: const Text(
          'Produk',
          style: TextStyle(color: Colors.white), // Warna teks putih
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // 🔍 Search Field
            // 🔍 Search Field tanpa bayangan
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                ), // outline border di Container
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search, color: Colors.black54),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: controller.setSearchQuery,
                      decoration: const InputDecoration(
                        hintText: 'Cari Nama Produk',
                        border: InputBorder.none, // tanpa border tambahan
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 📦 List Barang
            Expanded(
              child: Obx(() {
                final items = controller.filteredBarang;
                return RefreshIndicator(
                  onRefresh: controller.fetchBarang,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final barang = items[index];
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Barang : ${barang.namaBarang}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Stok : ${barang.stok}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Brand : ${barang.brand}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Lokasi : ${barang.lokasiPenyimpanan}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
