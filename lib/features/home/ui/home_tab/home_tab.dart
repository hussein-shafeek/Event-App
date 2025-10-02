import 'package:evently/core/models/category_model.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/utils/event_item.dart';
import 'package:evently/features/home/ui/home_tab/home_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  CategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    EventsProvider eventsProvider = Provider.of<EventsProvider>(context);
    return Column(
      children: [
        HomeHeader(),
        const SizedBox(height: 16),
        Expanded(
          // 3. استخدام StreamBuilder لجلب البيانات اللحظية
          child: StreamBuilder<List<EventModel>>(
            stream: FireBaseService.getEventStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No events found.'));
              } else {
                final allEvents = snapshot.data!;
                List<EventModel> displayedEvents = allEvents;

                // 4. تطبيق منطق الفلتر مباشرة على البيانات التي وصلت من الـ Stream
                if (_selectedCategory != null) {
                  displayedEvents =
                      allEvents
                          .where((event) => event.category == _selectedCategory)
                          .toList();
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
