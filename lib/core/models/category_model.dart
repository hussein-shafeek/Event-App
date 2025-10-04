import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryModel {
  int id;
  String name;
  IconData icon;
  String imageName;

  CategoryModel({
    required this.id,
    required this.imageName,
    required this.name,
    required this.icon,
  });

  static List<CategoryModel> categories = [
    CategoryModel(
      id: 1,
      imageName: 'sport',
      name: 'Sport',
      icon: Icons.sports_baseball_outlined,
    ),
    CategoryModel(
      id: 2,
      imageName: 'birthday',
      name: 'Birthday',
      icon: Icons.celebration_outlined,
    ),
    CategoryModel(
      id: 3,
      imageName: 'meeting',
      name: 'Meeting',
      icon: Icons.meeting_room_outlined,
    ),
    CategoryModel(
      id: 4,
      imageName: 'gaming',
      name: 'Gaming',
      icon: Icons.games_outlined,
    ),

    CategoryModel(
      id: 5,
      imageName: 'book',
      name: 'Book',
      icon: Icons.menu_book,
    ),
    CategoryModel(
      id: 6,
      imageName: 'eating',
      name: 'Eating',
      icon: Icons.restaurant,
    ),
    CategoryModel(
      id: 7,
      imageName: 'exhibition',
      name: 'Exhibition',
      icon: Icons.art_track,
    ),
    CategoryModel(
      id: 8,
      imageName: 'holiday',
      name: 'Holiday',
      icon: Icons.beach_access,
    ),
    CategoryModel(
      id: 9,
      imageName: 'workshop',
      name: 'Workshop',
      icon: Icons.handyman,
    ),
  ];
}
