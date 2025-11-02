import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEventLogic {
  static Future<void> updateEvent({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required EventModel oldEvent,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required String title,
    required String description,
    required category,
  }) async {
    final appLocalizations = AppLocalizations.of(context)!;

    if (!formKey.currentState!.validate()) return;

    try {
      DateTime dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final updatedEvent = EventModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        id: oldEvent.id,
        category: category,
        title: title,
        description: description,
        dateTime: dateTime,
        lat: oldEvent.lat,
        long: oldEvent.long,
        address: oldEvent.address,
      );

      await FireBaseService.updateEvent(updatedEvent);

      if (context.mounted) {
        Navigator.of(context).pop(updatedEvent);
        UIUtils.showSuccessMessage(context, appLocalizations.eventUpdated);
      }
    } catch (error) {
      UIUtils.showErrorMessage(context, appLocalizations.eventError);
    }
  }
}
