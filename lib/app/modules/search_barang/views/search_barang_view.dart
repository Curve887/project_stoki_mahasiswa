import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_barang_controller.dart';

class SearchBarangView extends GetView<SearchBarangController> {
  const SearchBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[800],
        title: const Text('Produk', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: controller.setSearchQuery,
                      decoration: const InputDecoration(
                        hintText: 'Cari Nama Produk',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List View
            Expanded(
              child: Obx(() {
                final items = controller.filteredBarang;
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white),
                  itemBuilder: (context, index) {
                    final barang = items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 5),
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
