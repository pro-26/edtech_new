import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/core/utils/helpers/toast_helper.dart';
import 'package:ed_tech/app/data/services/auth_service.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

/*
  This controller handles the authentication logic for the app.
  It manages the user login processes.

  created by : Muhammed Shabeer OP
  date : 2025-08-10
  updated date : 2025-08-10
 */

class AuthController extends GetxController {
  RxBool checked = false.obs;
  RxBool isVisible = false.obs;
  RxBool isLoading = false.obs;
  RxString phone = ''.obs;
  RxString password = ''.obs;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void signin() async {
    phone.value = phoneController.text.trim();
    password.value = passwordController.text.trim();

    if (phone.value.isEmpty || password.value.isEmpty) {
      Get.find<ToastHelper>().showError('Please enter phone and password');
      return;
    }

    isLoading.value = true;

    print(phone.value);
    print(password.value);

    final success = await Get.find<AuthService>().login(
      phone.value,
      password.value,
    );

    isLoading.value = false;

    if (success) {
      Get.find<ToastHelper>().showSuccess('Login successful');
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.find<ToastHelper>().showError('Invalid phone number or password');
    }
  }
}
