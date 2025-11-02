import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FireBaseService {
  static CollectionReference<EventModel> getEventCollection() =>
      FirebaseFirestore.instance
          .collection('events')
          .withConverter<EventModel>(
            fromFirestore:
                (snapshot, _) =>
                    EventModel.fromJson(snapshot.data()!, snapshot.id),
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

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("No logged in user");

    event.userId = currentUser.uid;
    event.createdAt = DateTime.now();

    await doc.set(event);
  }

  static Future<List<EventModel>> getEvents() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("No user logged in");

    final eventCollection = getEventCollection();

    try {
      final querySnapshot =
          await eventCollection
              .where('userId', isEqualTo: currentUser.uid)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("⚠️ Error loading events: $e");
      // fallback في حالة الداتا القديمة مافيهاش createdAt
      final querySnapshot =
          await eventCollection
              .where('userId', isEqualTo: currentUser.uid)
              .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
  }

  static Stream<List<EventModel>> getEventStream() {
    return FirebaseAuth.instance.authStateChanges().switchMap((user) {
      if (user == null) {
        // المستخدم مش داخل => نرجع Stream فاضي لكن ما يقفش
        return Stream.value([]);
      }

      return getEventCollection()
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (querySnapshot) =>
                querySnapshot.docs.map((doc) => doc.data()).toList(),
          );
    });
  }

  static Future<void> deleteEvent(String eventId) async {
    final eventCollection = getEventCollection();
    await eventCollection.doc(eventId).delete();
  }

  static Future<void> updateEvent(EventModel event) async {
    final eventCollection = getEventCollection();
    await eventCollection.doc(event.id).update(event.toJson());
  }

  static Stream<EventModel?> watchEvent(String id) {
    return getEventCollection().doc(id).snapshots().map((snap) => snap.data());
  }

  // ------------------- USERS -------------------

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

  static Future<void> createUser(UserModel user) async {
    final usersCollection = getUsersCollection();
    final doc = await usersCollection.doc(user.id).get();
    if (!doc.exists) {
      await usersCollection.doc(user.id).set(user);
    }
  }
}
