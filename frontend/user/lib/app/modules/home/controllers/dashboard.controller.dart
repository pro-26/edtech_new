import 'package:ed_tech/app/data/models/course.model.dart';
import 'package:ed_tech/app/data/models/user.model.dart';
import 'package:ed_tech/app/data/providers/api_provider.dart';
import 'package:ed_tech/app/data/services/auth_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final AuthService _authService = Get.find<AuthService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxList<Course> enrolledCourses = <Course>[].obs;
  final RxList<Course> featuredCourses = <Course>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      final userId = _authService.userId;
      if (userId.isNotEmpty) {
        await Future.wait([
          _fetchUserProfile(userId),
          _fetchEnrolledCourses(userId),
          _fetchFeaturedCourses(),
        ]);
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchUserProfile(String userId) async {
    final response = await _apiProvider.getUser(
      userId,
    ); // Assuming getUser exists and works
    // If getUser is commented out in ApiProvider, we might need to rely on what we have or uncomment it.
    // ApiProvider has commented out getUser. I should uncomment it or use another way.
    // For now, I will assume I can uncomment it or use a workaround.
    // Wait, ApiProvider has `// Future<Response> getUser(String id) => get('/users/$id');` commented out.
    // I should probably uncomment it in ApiProvider first.

    // Let's assume I'll fix ApiProvider.
    if (response.status.isOk) {
      currentUser.value = User.fromJson(response.body);
    }
  }

  Future<void> _fetchEnrolledCourses(String userId) async {
    final response = await _apiProvider.getUserEnrollments(userId);
    if (response.status.isOk) {
      final List data = response.body;
      // Assuming response is list of enrollments and each has a 'course' field
      enrolledCourses.value = data
          .map((e) => e['course'] != null ? Course.fromJson(e['course']) : null)
          .whereType<Course>()
          .toList();
    }
  }

  Future<void> _fetchFeaturedCourses() async {
    final response = await _apiProvider.getCourses();
    if (response.status.isOk) {
      final List data = response.body;
      featuredCourses.value = data.map((e) => Course.fromJson(e)).toList();
    }
  }
}
