import 'package:evently/core/utils/event_item.dart';
import 'package:evently/features/home/ui/home_tab/home_header.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Column(
      children: [
        HomeHeader(),
        SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, index) => EventItem(),
            separatorBuilder: (_, index) => SizedBox(height: 16),
            itemCount: 20,
          ),
        ),
      ],
    );
  }
}
