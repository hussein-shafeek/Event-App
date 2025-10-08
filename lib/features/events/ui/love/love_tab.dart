import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/event_item.dart';
import 'package:evently/l10n/app_localizations.dart';
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
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    // ignore: avoid_unnecessary_containers
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              DefaultTextFormField(
                hintText: appLocalizations.searchForEvent,
                prefixIconImageName: 'search',
                onChanged: (query) {},
              ),
              SizedBox(height: 16),
              Expanded(
                child:
                    eventsProvider.favouriteEvents.isEmpty
                        ? Center(
                          child: Text(
                            appLocalizations.noFavouriteEvents,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                        : ListView.separated(
                          itemBuilder:
                              (_, index) => EventItem(
                                eventsProvider.favouriteEvents[index],
                              ),
                          separatorBuilder: (_, index) => SizedBox(height: 16),
                          itemCount: eventsProvider.favouriteEvents.length,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
