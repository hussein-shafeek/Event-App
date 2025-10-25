import 'package:evently/features/events/ui/map/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationServices {
  static const String _apiKey = 'AIzaSyBQR7b5R9LiL9X_RPuZ1oWUxh7dH_nowtQ';
  static Future<LatLng?> pickLocation(BuildContext context) async {
    LatLng pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );
    return pickedLocation;
  }

  // static Future<String> getLocationAddress(LatLng latling) async {
  //   List<Placemark> placemarker = await placemarkFromCoordinates(
  //     latling.latitude,
  //     latling.longitude,
  //   );

  //   return '${placemarker[0].subLocality} , ${placemarker[0].locality} , ${placemarker[0].administrativeArea} , ${placemarker[0].postalCode}';
  // }

  static Future<String> getLocationAddress(
    BuildContext context,
    LatLng latLng,
  ) async {
    try {
      // نجيب اللغة الحالية من النظام (مثلاً: ar أو en أو fr)
      final String languageCode =
          View.of(context).platformDispatcher.locale.languageCode;

      // نجيب العنوان (المكتبة بتستخدم لغة الجهاز تلقائي)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        String name = place.name ?? '';
        String street = place.street ?? '';
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';
        String administrativeArea = place.administrativeArea ?? '';
        String country = place.country ?? '';

        String address = [
          if (name.isNotEmpty) name,
          if (street.isNotEmpty && street != name) street,
          if (subLocality.isNotEmpty) subLocality,
          if (locality.isNotEmpty) locality,
          if (administrativeArea.isNotEmpty) administrativeArea,
          if (country.isNotEmpty) country,
        ].join(', ');

        // نضيف فاصل سطر في حال اللغة العربية لتحسين التنسيق
        if (languageCode == 'ar') {
          address = address.replaceAll(', ', '، ');
        }

        print('🌍 [$languageCode] Address: $address');
        return address;
      }

      return '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
    } catch (e) {
      print('❌ Error getting address: $e');
      return '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
    }
  }
}
