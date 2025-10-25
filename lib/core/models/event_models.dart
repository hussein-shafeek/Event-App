import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/category_model.dart';

class EventModel {
  String id;
  String userId;
  CategoryModel category;
  String title;
  String description;
  DateTime dateTime; // وقت الحدث نفسه
  DateTime createdAt; // ✅ وقت الإنشاء الفعلي
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
    DateTime? createdAt, // ممكن ما تبعتوش، يتولّد تلقائيًا
    this.address,
    this.lat,
    this.long,
  }) : createdAt = createdAt ?? DateTime.now(); // ✅ وقت الإنشاء الافتراضي

  factory EventModel.fromJson(Map<String, dynamic> json, String docId) {
    return EventModel(
      id: docId,
      userId: json['userId'] ?? '',
      category: CategoryModel.categories.firstWhere(
        (c) => c.id == json['categoryId'],
        orElse: () => CategoryModel.categories.first,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime:
          (json['dateTime'] as Timestamp)
              .toDate(), // 🟢 غيّر الاسم لتوضيح الفرق
      createdAt:
          (json['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(), // ✅ جديد
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
    'dateTime': Timestamp.fromDate(dateTime), // 🟢 وقت الحدث
    'createdAt': Timestamp.fromDate(createdAt), // ✅ وقت الإنشاء
    'address': address,
    'lat': lat,
    'long': long,
  };
}
