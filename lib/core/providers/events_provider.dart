import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:flutter/material.dart';

class EventsProvider with ChangeNotifier {
  List<EventModel> allEvents = [];
  List<EventModel> displayedEvents = [];
  List<EventModel> favouriteEvents = [];

  CategoryModel? selectedCategory; // <-- جديد

  Future<void> getEvents() async {
    allEvents = await FireBaseService.getEvents();
    displayedEvents = allEvents;
    notifyListeners();
  }

  // للاستخدام التقليدي لو أردت
  void filterEvents(CategoryModel? category) {
    selectedCategory = category; // احفظ الاختيار
    if (category == null) {
      displayedEvents = allEvents;
    } else {
      displayedEvents =
          allEvents.where((event) => event.category.id == category.id).toList();
    }
    notifyListeners();
  }

  // Setter بسيط لتحديث الكاتيجوري من HomeHeader
  void setSelectedCategory(CategoryModel? category) {
    selectedCategory = category;
    // لاحقاً هنا لا نحدّث displayedEvents لأن الآن الفلترة حتتم على snapshot في ال-UI
    notifyListeners();
  }

  void filterFavouriteEvents(List<String> favouriteIds) {
    favouriteEvents =
        allEvents.where((event) => favouriteIds.contains(event.id)).toList();
    notifyListeners();
  }
}
