import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoveTabLogic {
  static Future<void> initLoveTab(BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    EventsProvider eventsProvider = Provider.of<EventsProvider>(
      context,
      listen: false,
    );

    // تحميل المستخدم الحالي
    await userProvider.loadCurrentUser();

    // تحميل جميع الفعاليات
    await eventsProvider.getEvents();

    // فلترة الفعاليات المفضلة
    List<String> favouriteEventIds =
        userProvider.currentUser!.favouriteEventsIds;
    eventsProvider.filterFavouriteEvents(favouriteEventIds);
  }
}
