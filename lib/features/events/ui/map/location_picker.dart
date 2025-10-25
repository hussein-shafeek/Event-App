import 'package:evently/core/providers/location_provider.dart';
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
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
        actions: [
          IconButton(
            onPressed: () {
              if (selectedLocation != null) {
                Navigator.pop(context, selectedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a location first')),
                );
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: GoogleMap(
        onTap: (LatLng latlng) {
          selectedLocation = latlng;
          setState(() {});
        },
        initialCameraPosition: CameraPosition(
          target:
              locationProvider.userLoccation ?? LatLng(31.2089017, 29.8885578),
          zoom: 14,
        ),
        markers:
            selectedLocation != null
                ? {
                  Marker(
                    markerId: MarkerId('selected location'),
                    position: selectedLocation!,
                  ),
                }
                : {},
      ),
    );
  }
}
