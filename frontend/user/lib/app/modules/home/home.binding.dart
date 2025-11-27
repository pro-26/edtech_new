import 'package:ed_tech/app/modules/home/controllers/dashboard.controller.dart';
import 'package:ed_tech/app/modules/home/controllers/subjects.controller.dart';
import 'package:get/get.dart';

import 'home.controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(DashboardController());
    Get.put(SubjectsController());
  }
}
