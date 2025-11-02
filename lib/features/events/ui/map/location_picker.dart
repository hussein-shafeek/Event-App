import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.chooseLocation), // 🔹 "اختر موقع الحدث"
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primary),
            tooltip: t.addEvent, // 🔹 لتوضيح وظيفة الزر للمستخدم
            onPressed: () {
              if (selectedLocation != null) {
                Navigator.pop(context, selectedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t.completeAllFields, // 🔹 "يرجى ملء جميع الحقول المطلوبة"
                      textAlign: TextAlign.center,
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary.withOpacity(0.9),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        onTap: (LatLng latLng) {
          selectedLocation = latLng;
          setState(() {});
        },
        initialCameraPosition: CameraPosition(
          target:
              locationProvider.userLoccation ??
              const LatLng(31.2089017, 29.8885578),
          zoom: 14,
        ),
        markers:
            selectedLocation != null
                ? {
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: selectedLocation!,
                  ),
                }
                : {},
      ),
    );
  }
}
