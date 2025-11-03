import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternetConnection {
  Future<bool> internetAvailable() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult[0] == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
