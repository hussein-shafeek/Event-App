import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:flutter/material.dart';

class EventsProvider with ChangeNotifier {
  List<EventModel> allEvents = [];
  List<EventModel> displayedEvents = [];
  List<EventModel> favouriteEvents = [];

  Future<void> getEvents() async {
    allEvents = await FireBaseService.getEvents();
    displayedEvents = allEvents;
    notifyListeners();
  }

  void filterEvents(CategoryModel? category) {
    if (category == null) {
      displayedEvents = allEvents;
    } else {
      displayedEvents =
          allEvents.where((event) => event.category == category).toList();
    }
    notifyListeners();
  }

  void filterFavouriteEvents(List<String> favouriteIds) {
    favouriteEvents =
        allEvents.where((event) => favouriteIds.contains(event.id)).toList();
    notifyListeners();
  }
}
