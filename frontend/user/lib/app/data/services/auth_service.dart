import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ed_tech/app/data/providers/api_provider.dart';

/*
  This service handles the authentication state of the user.
  It keeps track of whether the user is logged in or not.

  created by : Muhammed Shabeer OP
  date : 2025-08-10
  updated date : 2025-08-10
 */

class AuthService extends GetxService {
  final box = GetStorage(); // Initialize GetStorage
  final RxBool isLoggedIn = false.obs; // Track login state
  final RxString _accessToken = ''.obs;
  late final ApiProvider apiProvider;

  String get accessToken => _accessToken.value;

  /// Initialize the AuthService
  Future<AuthService> init() async {
    await GetStorage.init();
    isLoggedIn.value = box.read('isLoggedIn') ?? false;
    _accessToken.value = box.read('accessToken') ?? '';
    apiProvider = Get.put(ApiProvider());
    return this;
  }

  // Call this after successful login
  Future<bool> login(String phone, String password) async {
    try {
      final response = await apiProvider.login(phone, password);
      print(response.bodyString);
      if (response.status.hasError) {
        return false;
      }

      //recieves a access toke
      // {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZWZlNWI4Yi04YWIyLTRhYWItOWFhMC00NjNiMDU1YzlhODAiLCJyb2xlIjoiYWRtaW4iLCJwaG9uZSI6IjYyMzgyNjE2MTAiLCJpYXQiOjE3NjQyMzcwNzcsImV4cCI6MTc2NDI0MDY3N30.kpeW4Rf7SoDhI_9nr3K-QBN2ryokk-6NZm3n1BYY8UY"}
      final accessToken = response.body['access_token'];

      await box.write('accessToken', accessToken);
      await box.write('isLoggedIn', true);
      _accessToken.value = accessToken;
      isLoggedIn.value = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Call this after successful logout
  void logout() {
    box.write('isLoggedIn', false);
    box.remove('accessToken');
    isLoggedIn.value = false;
    _accessToken.value = '';
    Get.offAllNamed('/auth');
  }
}
