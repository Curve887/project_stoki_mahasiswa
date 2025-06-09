import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavbarMahasiswaController extends GetxController {
  final PersistentTabController tabController = PersistentTabController(
    initialIndex: 0,
  );

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
