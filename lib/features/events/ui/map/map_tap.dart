//import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/data/map_event_item.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

class MapTap extends StatefulWidget {
  const MapTap({super.key});

  @override
  State<MapTap> createState() => _MapTapState();
}

class _MapTapState extends State<MapTap> {
  Set<Circle> circles = {};
  GoogleMapController? mapController;
  // late LocationProvider locationProvider;

  @override
  void initState() {
    _initCircles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.userLoccation == null) {
      locationProvider.getCurrentLocation(context);
    }
    return eventsProvider.allEvents.isEmpty
        ? Center(child: Column(children: [Text('There Is No Events Added')]))
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
                    LatLng(31.2089017, 29.8885578),
                zoom: 16,
              ),
            ),

            Positioned(
              top: 35,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: CircleBorder(),
                  padding: EdgeInsetsDirectional.all(15),
                ),
                onPressed: () {
                  _centerMap(locationProvider.userLoccation!);
                },
                child: Icon(
                  Icons.my_location_outlined,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 0,

              right: 0,
              left: 0,
              child: SizedBox(
                height: height * 0.25,
                width: width * 83,
                child: ListView.builder(
                  padding: EdgeInsetsDirectional.only(
                    end: width * 0.02,
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  itemBuilder:
                      (context, index) => InkWell(
                        child: MapEventItem(
                          event: eventsProvider.allEvents[index],
                        ),
                        onTap: () {
                          var selectedEvent = eventsProvider.allEvents[index];
                          _centerMap(
                            LatLng(selectedEvent.lat!, selectedEvent.long!),
                          );
                          setState(() {});
                        },
                      ),
                  itemCount: eventsProvider.allEvents.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        );
  }

  void _centerMap(LatLng newLatLng) {
    mapController?.animateCamera(CameraUpdate.newLatLng(newLatLng));
  }

  void _initCircles() {
    EventsProvider eventsProvider = Provider.of<EventsProvider>(
      context,
      listen: false,
    );
    for (var event in eventsProvider.allEvents) {
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
}
