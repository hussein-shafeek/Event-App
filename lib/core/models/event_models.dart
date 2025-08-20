import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/category_model.dart';

class EventModel {
  String id;
  CategoryModel category;
  String title;
  String description;
  DateTime dateTime;

  EventModel({
    this.id = '',
    required this.category,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  /// Factory constructor علشان يشتغل مع Firestore
  factory EventModel.fromJson(Map<String, dynamic> json, String id) {
    return EventModel(
      id: id,
      category: CategoryModel.categories.firstWhere(
        (c) => c.id == json['categoryId'],
        orElse: () => CategoryModel.categories.first,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'categoryId': category.id,
    'timestamp': Timestamp.fromDate(dateTime),
  };
}
