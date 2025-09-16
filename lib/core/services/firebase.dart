import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseService {
  static CollectionReference<EventModel> getEventCollection() =>
      FirebaseFirestore.instance
          .collection('events')
          .withConverter<EventModel>(
            fromFirestore:
                (docSnapshot, _) =>
                    EventModel.fromJson(docSnapshot.data()!, docSnapshot.id),
            toFirestore: (event, _) => event.toJson(),
          );
  static CollectionReference<UserModel> getUsersCollection() =>
      FirebaseFirestore.instance
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore:
                (docSnapshot, _) => UserModel.fromJson(docSnapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  static Future<void> createEvent(EventModel event) async {
    final eventCollection = getEventCollection();
    final doc = eventCollection.doc();
    event.id = doc.id;
    await doc.set(event);
  }

  static Future<List<EventModel>> getEvents() async {
    final eventCollection = getEventCollection();
    final querySnapshot = await eventCollection.orderBy('timestamp').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  static Stream<List<EventModel>> getEventStream() {
    return getEventCollection().snapshots().map(
      (querySnapshot) => querySnapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  static Future<void> deleteEvent(String eventId) async {
    final eventCollection = getEventCollection();
    final eventDoc = eventCollection.doc(eventId);
    await eventDoc.delete();
  }

  static Future<void> updateEvent(EventModel event) async {
    final eventCollection = getEventCollection();
    final eventDoc = eventCollection.doc(event.id);
    await eventDoc.set(event);
  }

  static Stream<EventModel?> watchEvent(String id) {
    // بيراقب الدوكيومنت بتاع الحدث نفسه
    return getEventCollection()
        .doc(id)
        .snapshots()
        .map((snap) => snap.data()); // EventModel? (ممكن تبقى null لو اتمسح)
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel user = UserModel(
      favouriteEventsIds: [],
      id: credential.user!.uid,
      name: name,
      email: email,
    );
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    await usersCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    CollectionReference<UserModel> usersCollection = getUsersCollection();
    DocumentSnapshot<UserModel> docSnapshot =
        await usersCollection.doc(credential.user!.uid).get();
    return docSnapshot.data()!;
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();

  static Future<void> addEventToFavorites(String eventId) async {
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    DocumentReference<UserModel> userDoc = usersCollection.doc(
      FirebaseAuth.instance.currentUser!.uid,
    );
    return userDoc.update({
      'favouriteEventsIds': FieldValue.arrayUnion([eventId]),
    });
  }

  static Future<void> removeEventFromFavorites(String eventId) async {
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    DocumentReference<UserModel> userDoc = usersCollection.doc(
      FirebaseAuth.instance.currentUser!.uid,
    );
    return userDoc.update({
      'favouriteEventsIds': FieldValue.arrayRemove([eventId]),
    });
  }
}
