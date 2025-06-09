import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pinjam_barang_controller.dart';

class PinjamBarangView extends GetView<PinjamBarangController> {
  const PinjamBarangView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PinjamBarangView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PinjamBarangView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
