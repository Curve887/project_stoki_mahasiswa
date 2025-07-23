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
              // Gambar Mahasiswa di atas form
              Image.asset(
                'assets/image/mahasiswa.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 24),

              // Email TextField
              Transform.scale(
                scale: 0.95,
                child: TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Email tidak valid',
                ),
              ),
              const SizedBox(height: 16),

              // Password TextField
              Transform.scale(
                scale: 0.95,
                child: TextFormField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Minimal 6 karakter',
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Login
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                );
              }),
              const SizedBox(height: 16),

              // Daftar akun
              TextButton(
                onPressed: () {
                  Get.lazyPut<RegisterMahasiswaController>(
                    () => RegisterMahasiswaController(),
                  );
                  Get.to(() => const RegisterMahasiswaView());
                },
                child: const Text(
                  "Belum punya akun? Daftar di sini",
                  style: TextStyle(color: Colors.black),
                ),
              ),

              // Forgot Password
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
