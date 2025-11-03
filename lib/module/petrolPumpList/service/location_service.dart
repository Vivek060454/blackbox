import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<PermissionStatus> checkLocationPermission() async {
    return await Permission.location.status;
  }

  Future<PermissionStatus> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status;
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    PermissionStatus permission = await checkLocationPermission();
    if (permission == PermissionStatus.denied) {
      permission = await requestLocationPermission();
      if (permission == PermissionStatus.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == PermissionStatus.permanentlyDenied) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Map<String, double>?> getLocation() async {
    try {
      final position = await getCurrentLocation();
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      return null;
    }
  }
}

