import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  List<String> favouriteEventsIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.favouriteEventsIds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'favouriteEventsIds': favouriteEventsIds,
  };

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        favouriteEventsIds:
            (json['favouriteEventsIds'] as List<dynamic>? ?? []).cast<String>(),
      );
}

extension on JsonCodec {
  void operator [](String other) {}
}
