import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/category_model.dart';

class EventModel {
  String id;
  String userId;
  CategoryModel category;
  String title;
  String description;
  DateTime dateTime;
  double? long;
  double? lat;
  String? address;

  EventModel({
    this.id = '',
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    required this.dateTime,
    this.address,
    this.lat,
    this.long,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String docId) {
    return EventModel(
      id: docId, //  Use docId, not json['id']
      userId: json['userId'] ?? '',
      category: CategoryModel.categories.firstWhere(
        (c) => c.id == json['categoryId'],
        orElse: () => CategoryModel.categories.first,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: (json['timestamp'] as Timestamp).toDate(),
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'categoryId': category.id,
    'timestamp': Timestamp.fromDate(dateTime),
    'address': address,
    'lat': lat,
    'long': long,
  };
}
