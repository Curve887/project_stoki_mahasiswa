import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_mahasiswa_controller.dart';

class RegisterMahasiswaView extends GetView<RegisterMahasiswaController> {
  const RegisterMahasiswaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register Mahasiswa'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Silahkan Daftar Terlebih Dahulu',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Logo Gambar
              Center(
                child: Image.asset('assets/image/daftar.png', height: 300),
              ),

              // Text Fields
              _buildTextField(
                controller.emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(controller.namaController, label: 'Nama'),
              _buildTextField(
                controller.nimController,
                label: 'NIM',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(controller.prodiController, label: 'Prodi'),
              _buildTextField(
                controller.passwordController,
                label: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // Tombol Daftar di Bawah
              ElevatedButton(
                onPressed: controller.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }
}
