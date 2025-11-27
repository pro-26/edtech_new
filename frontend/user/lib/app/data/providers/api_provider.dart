import 'package:get/get.dart';
import 'package:ed_tech/app/core/values/constants.dart';
import 'package:ed_tech/app/data/services/auth_service.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppwriteConstants.apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 30);

    // Add request modifier to include token if available
    httpClient.addRequestModifier<dynamic>((request) {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn.value && authService.accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${authService.accessToken}';
      }
      return request;
    });
  }

  Future<Response> login(String phoneNumber, String password) =>
      post('/auth/login', {'phoneNumber': phoneNumber, 'password': password});

  // Users Module
  Future<Response> createUser(Map data) => post('/users', data);
  Future<Response> getUsers() => get('/users');
  Future<Response> getUser(String id) => get('/users/$id');
  Future<Response> updateUser(String id, Map data) => put('/users/$id', data);
  Future<Response> deleteUser(String id) => delete('/users/$id');

  // Instructors Module
  Future<Response> createInstructor(Map data) => post('/instructors', data);
  Future<Response> getInstructors() => get('/instructors');
  Future<Response> getInstructor(String id) => get('/instructors/$id');
  Future<Response> updateInstructor(String id, Map data) =>
      put('/instructors/$id', data);

  // Courses Module
  Future<Response> createCourse(Map data) => post('/courses', data);
  Future<Response> getCourses() => get('/courses');
  Future<Response> getCourse(String id) => get('/courses/$id');
  Future<Response> updateCourse(String id, Map data) =>
      put('/courses/$id', data);
  Future<Response> deleteCourse(String id) => delete('/courses/$id');

  // Lessons Module
  Future<Response> createLesson(Map data) => post('/lessons', data);
  Future<Response> getLessons(Map<String, dynamic>? query) =>
      get('/lessons', query: query);
  Future<Response> getLesson(String id) => get('/lessons/$id');
  Future<Response> updateLesson(String id, Map data) =>
      put('/lessons/$id', data);
  Future<Response> deleteLesson(String id) => delete('/lessons/$id');

  // Quizzes Module
  Future<Response> createQuiz(Map data) => post('/quizzes', data);
  Future<Response> getQuizzes() => get('/quizzes');
  Future<Response> submitQuiz(String id, Map data) =>
      post('/quizzes/$id/submit', data);

  // Progress Module
  Future<Response> updateProgress(Map data) => post('/progress', data);
  Future<Response> getUserProgress(String userId) =>
      get('/progress/user/$userId');
  Future<Response> getCourseProgress(String courseId) =>
      get('/progress/course/$courseId');

  // Gamification Module
  Future<Response> getBadges() => get('/gamification/badges');
  Future<Response> getLeaderboard(String courseId) =>
      get('/gamification/leaderboard/$courseId');
  Future<Response> getUserBadges(String userId) =>
      get('/gamification/user/$userId/badges');

  // Enrollments Module
  Future<Response> enroll(Map data) => post('/enrollments', data);
  Future<Response> getUserEnrollments(String userId) =>
      get('/enrollments/user/$userId');
  Future<Response> updateEnrollment(String id, Map data) =>
      put('/enrollments/$id', data);

  // Transactions Module
  Future<Response> createTransaction(Map data) => post('/transactions', data);
  Future<Response> getUserTransactions(String userId) =>
      get('/transactions/user/$userId');

  // Notifications Module
  Future<Response> getNotifications() => get('/notifications');
  Future<Response> markNotificationRead(String id) =>
      put('/notifications/$id/read', {});
}
