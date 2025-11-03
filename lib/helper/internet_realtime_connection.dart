import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  var showBackOnline = false.obs;
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkInitialConnection();
    monitorNetworkChanges();
  }

  // Check the initial network connection state
  Future<void> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(
        result.isNotEmpty ? result : [ConnectivityResult.none]);
  }

  // Listen for network connection changes
  void monitorNetworkChanges() {
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results : [ConnectivityResult.none];
      _updateConnectionStatus(result);
    });
  }

  // Update connection status and handle UI-related tasks
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    final wasConnected = isConnected.value;
    final newConnectionState =
    result.contains(ConnectivityResult.none) ? false : true;

    if (newConnectionState != wasConnected) {
      if (!newConnectionState) {
        // Lost connection
        isConnected.value = false;
      } else {
        // Connection restored
        isConnected.value = true;
        showBackOnlineNotification();
      }
    }

  }

  // Show "Back Online" message for a few seconds
  void showBackOnlineNotification() {
    showBackOnline.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showBackOnline.value = false;
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
