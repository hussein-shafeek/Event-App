import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/category_model.dart';
import 'package:flutter/foundation.dart';

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
  EventModel.fromjson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        category: CategoryModel.categories.firstWhere(
          (Category) => Category.id == json['categoryId'],
        ),
        title: json['title'],
        description: json['description'],
        dateTime: (json['timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'categoryId': category.id,
    'timestamp': Timestamp.fromDate(dateTime),
  };
}
