import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kembalikan_barang_controller.dart';

class KembalikanBarangView extends GetView<KembalikanBarangController> {
  const KembalikanBarangView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KembalikanBarangView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KembalikanBarangView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
