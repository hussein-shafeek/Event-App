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

  static Future<List<EventModel>> getEvents() async {
    CollectionReference<EventModel> eventCollection = getEventCollection();
    QuerySnapshot<EventModel> querySnapshot =
        await eventCollection.orderBy('timestamp').get();
    return querySnapshot.docs.map((docScapshot) => docScapshot.data()).toList();
  }

  static Stream<List<EventModel>> getEventStream() {
    return getEventCollection().snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  static Future<void> deleteEvent(String eventId) async {
    // 1. Get a reference to the events collection
    CollectionReference<EventModel> eventCollection = getEventCollection();

    // 2. Get a reference to the specific document to delete using its ID
    DocumentReference<EventModel> eventDoc = eventCollection.doc(eventId);

    // 3. Delete the document
    await eventDoc.delete();
  }

  static Future<void> updateEvent(EventModel event) async {
    // 1. Get a reference to the events collection
    CollectionReference<EventModel> eventCollection = getEventCollection();

    // 2. Get the specific document to update using its ID
    DocumentReference<EventModel> eventDoc = eventCollection.doc(event.id);

    // 3. Update the document with the new data
    // The `set` method with a merge option is great for updating specific fields
    // but in this case, we're replacing the whole object, so `set` alone is fine.
    await eventDoc.set(event);
  }
}
