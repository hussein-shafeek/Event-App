import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTabLogic {
  /// 🔹 تهيئة الدوائر الخاصة بالأحداث على الخريطة
  static Set<Circle> initCircles(BuildContext context) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    Set<Circle> circles = {};

    for (var event in eventsProvider.allEvents) {
      if (event.lat != null && event.long != null && event.id.isNotEmpty) {
        circles.add(
          Circle(
            circleId: CircleId(event.id),
            center: LatLng(event.lat!, event.long!),
            radius: 10,
            fillColor: AppColors.black,
            strokeWidth: 25,
            strokeColor: AppColors.black.withValues(alpha: 0.2),
          ),
        );
      }
    }
    return circles;
  }

  /// 🔹 تحريك الكاميرا إلى موقع جديد
  static void centerMap(GoogleMapController? controller, LatLng newLatLng) {
    controller?.animateCamera(CameraUpdate.newLatLng(newLatLng));
  }
}
