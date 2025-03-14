import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class GateController extends GetxController {
  //TODO: Implement GateController
  // final supabase = Supabase.instance.client; // Supabase client instance
  final Connectivity _connectivity = Connectivity();
  RxBool hasInternet = true.obs; // Observable for internet connection status
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Check if the list contains any active network connection type
      if (results.contains(ConnectivityResult.none)) {
        hasInternet.value = false;
        Get.offAllNamed('/no-internet');
        isLoading.value = false;
      } else {
        hasInternet.value = true;
        Get.offNamed('/navigation-screen');
      }
    });

    // Initial check for internet and authentication
    _checkInternetConnection();
  }

  void retryConnection() {
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    isLoading.value = true; // Start loading
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      hasInternet.value = false;
      Get.offAllNamed('/no-internet');
      isLoading.value = false; // Stop loading if there's no connection
    } else {
      hasInternet.value = true;
      Get.offNamed('/navigation-screen');
    }
    isLoading.value = false; // Stop loading after the check
  }
}
