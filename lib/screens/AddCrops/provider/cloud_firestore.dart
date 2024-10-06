import 'dart:io';
import 'package:agro_xplore/screens/Navigation/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference collectionUsers = db.collection('users');
CollectionReference collectionCrops = db.collection('crops');
// CollectionReference collectionTools = db.collection('tools');
FirebaseStorage get storage => FirebaseStorage.instance;

// guardar datos del evento
Future<void> addCrop(
  String title,
  String description,
  String referenceLocation,
  String type,
  File? image,
  double? latitude,
  double? longitude,
  DateTime showingDate,
  double? area,
) async {
  String? imageURL;
  final docRef = collectionCrops.doc();
  final docId = docRef.id;
  if (image != null) {
    final ref = storage.ref().child('crops').child(docId);
    await ref.putFile(image);
    imageURL = await ref.getDownloadURL();
  }
  final newDocument = {
    'id': docId,
    'title': title,
    'description': description,
    'imageURL': imageURL,
    'type': type,
    'latitude': latitude,
    'longitude': longitude,
    'referenceLocation': referenceLocation,
    'showingDate': showingDate,
  };

  print('My user ID firebase: ${me.id}');

  await docRef.set(newDocument);
  await collectionUsers.doc(me.id).collection('myCrops').add({
    'id': docId,
    'title': title,
    'imageURL': imageURL,
    'showingDate': showingDate,
    'latitude': latitude,
    'longitude': longitude,
    'referenceLocation': referenceLocation,
  });
}
