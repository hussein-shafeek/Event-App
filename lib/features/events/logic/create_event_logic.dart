import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventLogic {
  static Future<void> createEvent({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required CategoryModel selectedCategory,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required DateTime? selectedDate,
    required TimeOfDay? selectedTime,
    required LatLng? locationLatLng,
    required String? address,
  }) async {
    final appLocalizations = AppLocalizations.of(context)!;

    if (formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        locationLatLng != null &&
        address != null) {
      try {
        DateTime dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        EventModel event = EventModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          category: selectedCategory,
          title: titleController.text,
          description: descriptionController.text,
          dateTime: dateTime,
          lat: locationLatLng.latitude,
          long: locationLatLng.longitude,
          address: address,
        );

        await FireBaseService.createEvent(event);

        Navigator.of(context).pop();
        UIUtils.showSuccessMessage(context, appLocalizations.eventAdded);
      } catch (error) {
        String errorMessage = appLocalizations.eventError;
        if (error is FirebaseException) {
          errorMessage = error.message ?? appLocalizations.unexpectedError;
        }
        UIUtils.showErrorMessage(context, errorMessage);
      }
    } else {
      UIUtils.showErrorMessage(context, appLocalizations.completeAllFields);
    }
  }
}
