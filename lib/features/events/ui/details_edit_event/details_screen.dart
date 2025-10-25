import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
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
  late EventModel initialEvent; // بناخدها مرّة من arguments

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialEvent = ModalRoute.of(context)!.settings.arguments as EventModel;
    _initCircles();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final text = Theme.of(context).textTheme;
    final formatter = DateFormat('dd MMMM yyyy, hh:mm a');
    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    var eventModel = ModalRoute.of(context)!.settings.arguments as EventModel;
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.userLoccation == null) {
      locationProvider.getCurrentLocation(context);
    }

    return StreamBuilder<EventModel?>(
      stream: FireBaseService.watchEvent(initialEvent.id),
      builder: (context, snapshot) {
        // لو الدوك اتعمله delete نرجع للشاشة اللي قبلها
        if (snapshot.hasData && snapshot.data == null) {
          // اتأكد إننا على فريم بعد البناء
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.pop(context);
          });
          return const SizedBox.shrink();
        }

        // أول مرة ممكن ما يكونش في بيانات، اعرض النسخة المبدئية (arguments)
        final event = snapshot.data ?? initialEvent;
        if (event.lat == null || event.long == null) {
          return const Scaffold(
            body: Center(child: Text("Event location not available")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Event Details'),
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
                onPressed: () async {
                  // نبعت أحدث نسخة للـ Edit
                  await Navigator.pushNamed(
                    context,
                    AppRoutes.editEvent,
                    arguments: event,
                  );
                  // مش محتاجين setState.. الـ Stream هيحدّث لوحده
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppColors.red),
                onPressed: () async {
                  await FireBaseService.deleteEvent(event.id);
                  // ignore: use_build_context_synchronously
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
                                DateFormat('d MMMM yyy').format(event.dateTime),
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              eventModel.address ?? '',
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
                                  _centerMap(locationProvider.userLoccation!);
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
                    'Description',
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

  void _centerMap(LatLng newLatLng) {
    mapController?.animateCamera(CameraUpdate.newLatLng(newLatLng));
  }

  void _initCircles() {
    EventsProvider eventsProvider = Provider.of<EventsProvider>(
      context,
      listen: false,
    );

    circles.clear();

    for (var event in eventsProvider.allEvents) {
      // ✅ تجاهل أي event ملوش lat/long
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
  }
}
