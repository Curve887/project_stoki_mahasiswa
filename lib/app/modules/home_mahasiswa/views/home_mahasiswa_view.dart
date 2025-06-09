import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_mahasiswa_controller.dart';

class HomeMahasiswaView extends GetView<HomeMahasiswaController> {
  const HomeMahasiswaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeMahasiswaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeMahasiswaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
