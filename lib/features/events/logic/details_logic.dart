import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DetailsLogic {
  static Set<Circle> initCircles(
    BuildContext context,
    EventModel initialEvent,
  ) {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);

    final Set<Circle> circles = {};

    for (var event in eventsProvider.allEvents) {
      if (event.lat == null || event.long == null) continue;

      final isCurrentEvent = event.id == initialEvent.id;

      circles.add(
        Circle(
          circleId: CircleId(event.id),
          center: LatLng(event.lat!, event.long!),
          radius: 7,
          fillColor: isCurrentEvent ? AppColors.primary : AppColors.black,
          strokeWidth: 20,
          strokeColor:
              isCurrentEvent
                  ? AppColors.primary.withValues(alpha: 0.9)
                  : AppColors.black.withValues(alpha: 0.9),
        ),
      );
    }

    return circles;
  }

  static void centerMap(GoogleMapController? controller, LatLng newLatLng) {
    controller?.animateCamera(CameraUpdate.newLatLng(newLatLng));
  }
}
