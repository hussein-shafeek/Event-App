import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/utils/event_item.dart';
import 'package:evently/features/home/ui/home_tab/home_header.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        HomeHeader(),
        const SizedBox(height: 16),
        Expanded(
          child: StreamBuilder<List<EventModel>>(
            stream: FireBaseService.getEventStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(appLocalizations.somethingWrong));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(appLocalizations.noEventsFound));
              } else {
                final eventsProvider = Provider.of<EventsProvider>(context);

                final events = snapshot.data!;
                final selectedCategory = eventsProvider.selectedCategory;

                final displayedEvents =
                    selectedCategory == null
                        ? events
                        : events
                            .where((e) => e.category.id == selectedCategory.id)
                            .toList();

                if (displayedEvents.isEmpty) {
                  return Center(child: Text(appLocalizations.noEventsFound));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (_, index) => EventItem(displayedEvents[index]),
                  separatorBuilder: (_, index) => const SizedBox(height: 16),
                  itemCount: displayedEvents.length,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
