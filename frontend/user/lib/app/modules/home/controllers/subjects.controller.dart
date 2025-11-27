/*
  SubjectsController
  - Purpose: Manages the state of the subjects view. Fetches courses from the API and filters them based on the selected filter.
  - Notes: Uses GetxController for state management. Depends on ApiProvider for API calls.
  - Author: Muhammed Shabeer OP
  - Added: 2025-11-27 (annotation)
*/

import 'package:ed_tech/app/data/models/course.model.dart';
import 'package:ed_tech/app/data/providers/api_provider.dart';
import 'package:get/get.dart';

class SubjectsController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  final RxList<Course> allCourses = <Course>[].obs;
  final RxList<Course> displayedCourses = <Course>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.getCourses();
      if (response.status.isOk) {
        final List data = response.body;
        allCourses.value = data.map((e) => Course.fromJson(e)).toList();
        filterCourses(selectedFilter.value);
      }
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterCourses(String filter) {
    selectedFilter.value = filter;
    if (filter == 'All') {
      displayedCourses.value = allCourses;
    } else if (filter == 'My Subjects') {
      // Logic to filter my subjects (requires enrolled courses info, maybe inject DashboardController or fetch again)
      // For now, just show all or empty
      displayedCourses.value = [];
    } else if (filter == 'Completed') {
      displayedCourses.value = [];
    }
  }
}
