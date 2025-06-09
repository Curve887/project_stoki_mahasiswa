import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../controllers/navbar_mahasiswa_controller.dart';
import '../../home_mahasiswa/views/home_mahasiswa_view.dart';
import '../../search_barang/views/search_barang_view.dart';
import '../../pinjam_barang/views/pinjam_barang_view.dart';
import '../../kembalikan_barang/views/kembalikan_barang_view.dart';
import '../../profil_mahasiswa/views/profil_mahasiswa_view.dart';

class NavbarMahasiswaView extends GetView<NavbarMahasiswaController> {
  const NavbarMahasiswaView({super.key});

  List<Widget> _buildScreens() {
    return const [
      HomeMahasiswaView(),
      SearchBarangView(),
      PinjamBarangView(),
      KembalikanBarangView(),
      ProfilMahasiswaView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.yellow,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: "Cari",
        activeColorPrimary: Colors.yellow,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.assignment_outlined),
        title: "Pinjam",
        activeColorPrimary: Colors.yellow,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.assignment_return_outlined),
        title: "Kembalikan",
        activeColorPrimary: Colors.yellow,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profil",
        activeColorPrimary: Colors.yellow,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller.tabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style1,
      backgroundColor: Colors.grey[900]!,
      confineToSafeArea: true,
      stateManagement: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
