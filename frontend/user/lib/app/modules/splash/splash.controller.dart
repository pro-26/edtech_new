import 'package:get/get.dart';

import 'package:ed_tech/app/routes/app_pages.dart';
import 'package:ed_tech/app/data/services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // todo: check if user is logged in
    super.onInit();
  }

  @override
  void onReady() {
    // simulate a delay
    Future.delayed(const Duration(seconds: 2), () {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn.value) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.AUTH);
      }
    });

    super.onReady();
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
