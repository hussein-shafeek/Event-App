import 'package:flutter/material.dart';

class CategoryModel {
  int id;
  String translationKey;
  IconData icon;
  String imageName;

  CategoryModel({
    required this.id,
    required this.imageName,
    required this.translationKey,
    required this.icon,
  });

  static List<CategoryModel> categories = [
    CategoryModel(
      id: 1,
      imageName: 'sport',
      translationKey: 'sport',
      icon: Icons.sports_baseball_outlined,
    ),
    CategoryModel(
      id: 2,
      imageName: 'birthday',
      translationKey: 'birthday',
      icon: Icons.celebration_outlined,
    ),
    CategoryModel(
      id: 3,
      imageName: 'meeting',
      translationKey: 'meeting',
      icon: Icons.meeting_room_outlined,
    ),
    CategoryModel(
      id: 4,
      imageName: 'gaming',
      translationKey: 'gaming',
      icon: Icons.games_outlined,
    ),
    CategoryModel(
      id: 5,
      imageName: 'book',
      translationKey: 'book',
      icon: Icons.menu_book,
    ),
    CategoryModel(
      id: 6,
      imageName: 'eating',
      translationKey: 'eating',
      icon: Icons.restaurant,
    ),
    CategoryModel(
      id: 7,
      imageName: 'exhibition',
      translationKey: 'exhibition',
      icon: Icons.art_track,
    ),
    CategoryModel(
      id: 8,
      imageName: 'holiday',
      translationKey: 'holiday',
      icon: Icons.beach_access,
    ),
    CategoryModel(
      id: 9,
      imageName: 'workshop',
      translationKey: 'workshop',
      icon: Icons.handyman,
    ),
  ];
}
