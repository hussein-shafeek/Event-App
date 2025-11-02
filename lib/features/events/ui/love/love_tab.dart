import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/event_item.dart';
import 'package:evently/features/events/logic/love_tab_logic.dart';
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
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoveTabLogic.initLoveTab(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    eventsProvider = Provider.of<EventsProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              DefaultTextFormField(
                hintText: appLocalizations.searchForEvent,
                prefixIconImageName: 'search',
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildFavouriteEventsList(context, appLocalizations),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteEventsList(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final filteredEvents =
        eventsProvider.favouriteEvents
            .where(
              (event) =>
                  event.title.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    if (filteredEvents.isEmpty) {
      return Center(
        child: Text(
          appLocalizations.noFavouriteEvents,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (_, index) => EventItem(filteredEvents[index]),
      separatorBuilder: (_, index) => const SizedBox(height: 16),
      itemCount: filteredEvents.length,
    );
  }
}
