import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/logic/details_logic.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Set<Circle> circles = {};
  GoogleMapController? mapController;
  late EventModel initialEvent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialEvent = ModalRoute.of(context)!.settings.arguments as EventModel;
    circles = DetailsLogic.initCircles(context, initialEvent);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final text = Theme.of(context).textTheme;
    final appLocalizations = AppLocalizations.of(context)!;

    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    var eventModel = ModalRoute.of(context)!.settings.arguments as EventModel;
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.userLoccation == null) {
      locationProvider.getCurrentLocation(context);
    }

    return StreamBuilder<EventModel?>(
      stream: FireBaseService.watchEvent(initialEvent.id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.pop(context);
          });
          return const SizedBox.shrink();
        }

        final event = snapshot.data ?? initialEvent;

        if (event.lat == null || event.long == null) {
          return Scaffold(
            body: Center(
              child: Text(appLocalizations.eventLocationNotAvailable),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(appLocalizations.eventDetails),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                tooltip: appLocalizations.editEvent,
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    AppRoutes.editEvent,
                    arguments: event,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.red),
                tooltip: appLocalizations.deleteEvent,
                onPressed: () async {
                  await FireBaseService.deleteEvent(event.id);
                  if (mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/${event.category.imageName}.png',
                      height: height * 0.23,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    event.title,
                    style: text.headlineSmall!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/calinder.svg'),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat(
                                  'd MMMM yyyy',
                                ).format(event.dateTime),
                                style: text.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'hh:mm a',
                                ).format(eventModel.dateTime),
                                style: text.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/location.svg'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              eventModel.address ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleMedium!.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: height * 0.35,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
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
                              target: LatLng(eventModel.lat!, eventModel.long!),
                              zoom: 15,
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                              ),
                              onPressed: () {
                                if (locationProvider.userLoccation != null) {
                                  DetailsLogic.centerMap(
                                    mapController,
                                    locationProvider.userLoccation!,
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.my_location_outlined,
                                color: AppColors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    appLocalizations.descriptionLabel,
                    style: text.titleMedium!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: text.titleMedium!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
