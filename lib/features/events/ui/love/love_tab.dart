import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/event_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoveTab extends StatefulWidget {
  const LoveTab({super.key});

  @override
  State<LoveTab> createState() => _LoveTabState();
}

class _LoveTabState extends State<LoveTab> {
  late EventsProvider eventsProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<String> favouriteEventIds =
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).currentUser!.favouriteEventsIds;
      eventsProvider.filterFavouriteEvents(favouriteEventIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    eventsProvider = Provider.of<EventsProvider>(context);
    // ignore: avoid_unnecessary_containers
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            DefaultTextFormField(
              hintText: 'Search For Event',
              prefixIconImageName: 'search',
              onChanged: (query) {},
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemBuilder:
                    (_, index) =>
                        EventItem(eventsProvider.favouriteEvents[index]),
                separatorBuilder: (_, index) => SizedBox(height: 16),
                itemCount: eventsProvider.favouriteEvents.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
