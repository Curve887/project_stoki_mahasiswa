import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_mahasiswa/bindings/home_mahasiswa_binding.dart';
import '../modules/home_mahasiswa/views/home_mahasiswa_view.dart';
import '../modules/kembalikan_barang/bindings/kembalikan_barang_binding.dart';
import '../modules/kembalikan_barang/views/kembalikan_barang_view.dart';
import '../modules/login_mahasiswa/bindings/login_mahasiswa_binding.dart';
import '../modules/login_mahasiswa/views/login_mahasiswa_view.dart';
import '../modules/navbar_mahasiswa/bindings/navbar_mahasiswa_binding.dart';
import '../modules/navbar_mahasiswa/views/navbar_mahasiswa_view.dart';

import '../modules/pinjam_barang/bindings/pinjam_barang_binding.dart';
import '../modules/pinjam_barang/views/pinjam_barang_view.dart';
import '../modules/profil_mahasiswa/bindings/profil_mahasiswa_binding.dart';
import '../modules/profil_mahasiswa/views/profil_mahasiswa_view.dart';
import '../modules/register_mahasiswa/bindings/register_mahasiswa_binding.dart';
import '../modules/register_mahasiswa/views/register_mahasiswa_view.dart';
import '../modules/search_barang/bindings/search_barang_binding.dart';
import '../modules/search_barang/views/search_barang_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_MAHASISWA,
      page: () => const LoginMahasiswaView(),
      binding: LoginMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_MAHASISWA,
      page: () => const RegisterMahasiswaView(),
      binding: RegisterMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME_MAHASISWA,
      page: () => const HomeMahasiswaView(),
      binding: HomeMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR_MAHASISWA,
      page: () => const NavbarMahasiswaView(),
      binding: NavbarMahasiswaBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_BARANG,
      page: () => const SearchBarangView(),
      binding: SearchBarangBinding(),
    ),
    GetPage(
      name: _Paths.PINJAM_BARANG,
      page: () => const PinjamBarangView(),
      binding: PinjamBarangBinding(),
    ),
    GetPage(
      name: _Paths.KEMBALIKAN_BARANG,
      page: () => const KembalikanBarangView(),
      binding: KembalikanBarangBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL_MAHASISWA,
      page: () => const ProfilMahasiswaView(),
      binding: ProfilMahasiswaBinding(),
    ),
  ];
}
