import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ToastHelper extends GetxService {
  static const int _defaultDuration = 3000;

  void showSuccess(String message, {int duration = _defaultDuration}) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(milliseconds: duration),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void showError(String message, {int duration = _defaultDuration}) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(milliseconds: duration),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void showInfo(String message, {int duration = _defaultDuration}) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: const Color.fromARGB(255, 225, 240, 252),
      colorText: Get.theme.colorScheme.onSurface,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(milliseconds: duration),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void showWarning(String message, {int duration = _defaultDuration}) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: const Color.fromARGB(255, 255, 237, 210),
      colorText: Get.theme.colorScheme.onSurface,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(milliseconds: duration),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
