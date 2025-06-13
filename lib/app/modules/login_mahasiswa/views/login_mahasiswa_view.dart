import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_mahasiswa_controller.dart';
import '../../register_mahasiswa/views/register_mahasiswa_view.dart';
import '../../register_mahasiswa/controllers/register_mahasiswa_controller.dart';

class LoginMahasiswaView extends GetView<LoginMahasiswaController> {
  const LoginMahasiswaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Mahasiswa'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : 'Email tidak valid',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : 'Minimal 6 karakter',
              ),
              const SizedBox(height: 20),
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                );
              }),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Lazy put the RegisterMahasiswaController
                  Get.lazyPut<RegisterMahasiswaController>(
                    () => RegisterMahasiswaController(),
                  );
                  // Navigasi ke halaman register
                  Get.to(() => const RegisterMahasiswaView());
                },
                child: const Text("Belum punya akun? Daftar di sini"),
              ),
              const SizedBox(height: 5),
              TextButton(onPressed: () {}, child: Text('Forgot Password?')),
            ],
          ),
        ),
      ),
    );
  }
}
