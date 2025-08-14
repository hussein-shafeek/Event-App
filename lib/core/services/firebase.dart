import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/event_models.dart';

class FireBaseService {
  static CollectionReference<EventModel> getEventCollection() =>
      FirebaseFirestore.instance
          .collection('events')
          .withConverter<EventModel>(
            fromFirestore:
                (docSnapshot, _) => EventModel.fromjson(docSnapshot.data()!),
            toFirestore: (event, _) => event.toJson(),
          );

  static Future<void> createEvent(EventModel event) async {
    CollectionReference<EventModel> eventCollection = getEventCollection();
    DocumentReference<EventModel> doc = eventCollection.doc();
    event.id = doc.id;
    doc.set(event);
  }
}
