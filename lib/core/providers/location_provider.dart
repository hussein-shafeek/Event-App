import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? userLoccation;

  Future<void> getCurrentLocation(BuildContext context) async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      Position myPositin = await Geolocator.getCurrentPosition();
      userLoccation = LatLng(myPositin.latitude, myPositin.longitude);
      notifyListeners();
    } else if (permissionStatus.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Location Permission Denied')));
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // var location = Location();
  // String locationMessage = '';
  // Future<void> getLocation() async {
  //   locationMessage = 'Checking Location Service';
  //   notifyListeners();
  //   bool locationPermissionGranted = await _getLocationPermission();
  //   if (!locationPermissionGranted) {
  //     locationMessage = 'Location Permisson Denied';
  //     notifyListeners();
  //     return;
  //   }
  // }

  // Future<bool> _getLocationPermission() async {
  //   var permissionStatus = await location.hasPermission();
  //   if (permissionStatus == PermissionStatus.denied) {
  //     permissionStatus == await location.requestPermission();
  //   }
  //   return permissionStatus == PermissionStatus.granted;
  // }
}
