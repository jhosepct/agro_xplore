import 'dart:io';
import '../../../home/view/main_screen.dart';
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
  // if (image != null) {
  //   final imagePath = 'crops/$docId/${path.basename(image.path)}';
  //   final storageRef = storage.ref(imagePath);
  //   await storageRef.putFile(image);
  //   imageURL = await storageRef.getDownloadURL();
  // }
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

Future<List<Map<String, dynamic>>> getUserCrops() async {
  try {
    // Obtiene la referencia a la colección, pero puede que no exista
    final userDocSnapshot = await collectionUsers.doc(me.id).get();

    // Si el documento del usuario no existe o no tiene la subcolección, devuelve una lista vacía
    if (!userDocSnapshot.exists) {
      return [];
    }

    // Consulta la subcolección 'myCrops'
    final userCropsSnapshot = await collectionUsers.doc(me.id).collection('myCrops').get();

    // Si no hay documentos en la subcolección, también devuelve una lista vacía
    if (userCropsSnapshot.docs.isEmpty) {
      return [];
    }

    // Mapea los documentos de la subcolección a una lista
    final userCrops = userCropsSnapshot.docs.map((doc) => doc.data()).toList();
    return userCrops;
  } catch (e) {
    // Manejo de cualquier excepción que ocurra durante la consulta
    print('Error fetching crops: $e');
    return [];
  }
}
