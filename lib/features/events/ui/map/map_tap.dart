import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/data/map_event_item.dart';
import 'package:evently/features/events/logic/map_tab_logic.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTap extends StatefulWidget {
  const MapTap({super.key});

  @override
  State<MapTap> createState() => _MapTapState();
}

class _MapTapState extends State<MapTap> {
  Set<Circle> circles = {};
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      circles = MapTabLogic.initCircles(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final eventsProvider = Provider.of<EventsProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);

    if (locationProvider.userLoccation == null) {
      locationProvider.getCurrentLocation(context);
    }

    return eventsProvider.allEvents.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocalizations.noEventsAdded,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        )
        : Stack(
          children: [
            GoogleMap(
              circles: circles,
              onMapCreated: (controller) {
                mapController = controller;
              },
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target:
                    locationProvider.userLoccation ??
                    const LatLng(31.2089017, 29.8885578),
                zoom: 16,
              ),
            ),

            // 🔹 زر تحديد الموقع الحالي
            Positioned(
              top: 35,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {
                  if (locationProvider.userLoccation != null) {
                    MapTabLogic.centerMap(
                      mapController,
                      locationProvider.userLoccation!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(appLocalizations.locationNotAvailableYet),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.my_location_outlined,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),

            // 🔹 شريط الأحداث
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SizedBox(
                height: height * 0.25,
                width: width * 0.83,
                child: ListView.builder(
                  padding: EdgeInsetsDirectional.only(
                    end: width * 0.02,
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: eventsProvider.allEvents.length,
                  itemBuilder: (context, index) {
                    final selectedEvent = eventsProvider.allEvents[index];
                    return InkWell(
                      child: MapEventItem(event: selectedEvent),
                      onTap: () {
                        MapTabLogic.centerMap(
                          mapController,
                          LatLng(selectedEvent.lat!, selectedEvent.long!),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
  }
}
