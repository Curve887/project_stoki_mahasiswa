import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 🔽 Tambahkan animasi/gambar di atas
            Image.asset('assets/image/lupa_password.png', height: 180),
            const SizedBox(height: 20),

            const Text(
              'Masukkan Email Mahasiswa',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.emailController.value = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.resetPassword,
              child: const Text('Kirim Link Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
