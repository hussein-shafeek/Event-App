import 'package:evently/core/models/user_model.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  void updateCurrentUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }

  String get userName => currentUser?.name ?? "Guest";

  bool checkIsFavouriteEvent(String eventId) {
    return currentUser!.favouriteEventsIds.contains(eventId);
  }

  void addEventToFavorites(String eventId) {
    FireBaseService.addEventToFavorites(eventId);
    currentUser!.favouriteEventsIds.add(eventId);
    notifyListeners();
  }

  void removeEventFromFavorites(String eventId) {
    FireBaseService.removeEventFromFavorites(eventId);
    currentUser!.favouriteEventsIds.remove(eventId);
    notifyListeners();
  }
}
