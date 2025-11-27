import 'package:ed_tech/app/modules/home/controllers/dashboard.controller.dart';
import 'package:ed_tech/app/modules/home/controllers/subjects.controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy‑load the controllers when the Home module is accessed
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SubjectsController>(() => SubjectsController());
  }
}
