import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/view/main_screen.dart';

CollectionReference projectsCollection =
    FirebaseFirestore.instance.collection('projects');

CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');

Future<List> getProjectsInside() async {
  List projectsInside = [];
  final projectSnapshot =
      await userCollection.doc(me.id).collection('projectsInside').get();
  if (projectSnapshot.docs.isNotEmpty) {
    projectsInside = projectSnapshot.docs.map((doc) => doc.data()).toList();
  }
  return projectsInside;
}

// import 'dart:math';

// class HomeFirestore {
//   CollectionReference collectionEvents =
//       FirebaseFirestore.instance.collection('events');
//   CollectionReference collectionUsers =
//       FirebaseFirestore.instance.collection('users');

// Future<List> getEventsIdsIAmFromUser() async {
//   DocumentReference docUser = collectionUsers.doc(me.id);
//   DocumentSnapshot snapshot = await docUser.get();
//   List eventsIdsIam = snapshot.get('eventsIdsIAm') ?? [];
//   return eventsIdsIam;
// }

// Future<Map?> getEventById(String idEvent) async {
//   Map? event;
//   DocumentReference docEvent = collectionEvents.doc(idEvent);
//   DocumentSnapshot snapshot = await docEvent.get();
//   if (snapshot.exists) {
//     event = snapshot.data() as Map;
//   }
//   return event;
// }

// Future<List<DocumentSnapshot>> getEventsFilterGeoHash(
//     double latitude, double longitude, DocumentSnapshot? lastDoc) async {
//   List<DocumentSnapshot> events = [];
//   int limit = 15;
//   GeoHasher geoHasher = GeoHasher();
//   String myGeoHash = geoHasher.encode(longitude, latitude, precision: 4);
//   Map<String, String> geoHash9 = geoHasher.neighbors(myGeoHash);
//   List listGeoHash9 = geoHash9.values.toList();
//   QuerySnapshot? querySnapshot;
//   QuerySnapshot? querySnapshotWhithNull;
//   if (lastDoc == null) {
//     querySnapshot = await collectionEvents
//         .where('geoHash', whereIn: listGeoHash9)
//         .where('date',
//             isGreaterThan: DateTime.now().subtract(const Duration(hours: 3)))
//         .orderBy(
//           'date',
//         )
//         .limit(limit)
//         .get();
//     querySnapshotWhithNull = await collectionEvents
//         .where('geoHash', isNull: true)
//         .where('date',
//             isGreaterThan: DateTime.now().subtract(const Duration(hours: 3)))
//         .orderBy(
//           'date',
//         )
//         .limit(limit)
//         .get();
//   } else {
//     querySnapshot = await collectionEvents
//         .where('geoHash', whereIn: listGeoHash9)
//         .where('date',
//             isGreaterThan: DateTime.now().subtract(const Duration(hours: 3)))
//         .orderBy(
//           'date',
//         )
//         .limit(limit)
//         .startAfterDocument(lastDoc)
//         .get();

//     querySnapshotWhithNull = await collectionEvents
//         .where('geoHash', isNull: true)
//         .where('date',
//             isGreaterThan: DateTime.now().subtract(const Duration(hours: 3)))
//         .orderBy(
//           'date',
//         )
//         .limit(limit)
//         .startAfterDocument(lastDoc)
//         .get();
//   }
//   if (querySnapshot.docs.isNotEmpty) {
//     events = querySnapshot.docs;
//   }
//   if (querySnapshotWhithNull.docs.isNotEmpty) {
//     events.addAll(querySnapshotWhithNull.docs);
//   }
//   return events;
// }

// Future<List<DocumentSnapshot>> getEventsFilterGeoHashAll(
//     double latitude, double longitude) async {
//   List<DocumentSnapshot> events = [];
//   GeoHasher geoHasher = GeoHasher();
//   String myGeoHash = geoHasher.encode(longitude, latitude, precision: 4);
//   Map<String, String> geoHash9 = geoHasher.neighbors(myGeoHash);
//   List<String> listGeoHash9 = geoHash9.values.toList();
//   QuerySnapshot? querySnapshot;
//   querySnapshot = await collectionEvents
//       .where('geoHash', whereIn: listGeoHash9)
//       .where('date',
//           isGreaterThan: DateTime.now().subtract(const Duration(hours: 3)))
//       .get();
//   if (querySnapshot.docs.isNotEmpty) {
//     events = querySnapshot.docs;
//   }
//   return events;
// }

// Future<void> sendIdEventToIAm(String idEvent, String nameEvent,
//     String descriptionEvent, DateTime date, int newCount) async {
//   DocumentReference docUser = collectionUsers.doc(me.id);
//   docUser.update({
//     'eventsIdsIAm': FieldValue.arrayUnion([idEvent]),
//     'count': newCount,
//   });
//   collectionEvents.doc(idEvent).update({
//     'members': FieldValue.arrayUnion([
//       {
//         'image': me.image,
//         'id': me.id,
//         'name': me.name,
//         'birthdate': me.birthdate,
//         'description': me.description,
//         'interests': me.interests,
//       }
//     ]),
//     'tokens': FieldValue.arrayUnion([me.token]),
//   });
//   await collectionUsers.doc(me.id).collection('eventsInside').add({
//     'idEvent': idEvent,
//     'nameEvent': nameEvent,
//     'descriptionEvent': descriptionEvent,
//     'date': date,
//     'isIAdmin': false,
//   });
// }

// Future<void> deleteEvent(String idEvent) async {
//   await collectionEvents.doc(idEvent).delete();
// }

// double distanciaCoordenadas(
//     double lat1, double lon1, double lat2, double lon2) {
//   const R = 6371; // Radio de la Tierra en km
//   var dLat = _radianes(lat2 - lat1);
//   var dLon = _radianes(lon2 - lon1);
//   var a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(_radianes(lat1)) *
//           cos(_radianes(lat2)) *
//           sin(dLon / 2) *
//           sin(dLon / 2);
//   var c = 2 * asin(sqrt(a));
//   var distancia = R * c;
//   return distancia;
// }

// double _radianes(double grados) {
//   return grados * pi / 180;
// }
// }

// Future<void> updateDate(DateTime newDateLimit, int count) async {
//   DocumentReference docUser =
//       FirebaseFirestore.instance.collection('users').doc(me.id);
//   await docUser.update({
//     'dateCreated': newDateLimit,
//     'count': count,
//   });
// }

Future<void> updateToken(String token) async {
  DocumentReference docUser =
      FirebaseFirestore.instance.collection('users').doc(me.id);
  await docUser.update({
    'token': token,
  });
}
