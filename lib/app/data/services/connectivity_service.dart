import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();
  final isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      isOnline.value = results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    isOnline.value = results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
  }
}
