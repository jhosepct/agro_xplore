import 'dart:developer';
import 'dart:io';
import 'package:agro_xplore/screens/Navigation/navigation.dart';
import 'package:agro_xplore/services/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference collectionUsers = db.collection('users');
CollectionReference collectionCrops = db.collection('crops');
// CollectionReference collectionTools = db.collection('tools');
FirebaseStorage get storage => FirebaseStorage.instance;

Map<int, String> monthNames = {
  1: 'JAN',
  2: 'FEB',
  3: 'MAR',
  4: 'APR',
  5: 'MAY',
  6: 'JUN',
  7: 'JUL',
  8: 'AUG',
  9: 'SEP',
  10: 'OCT',
  11: 'NOV',
  12: 'DEC'
};

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
  //Llamado al api
  Map<String, dynamic> result = await getService( area.toString(), showingDate.month.toString());

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
    'area': area,
    'watering': result['quantity'],
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
    'area': area,
    'watering': result['quantity'],
  });
}

Future<Map<String, String>> getEndpoints() async {
  try {
    // Accede a la colección 'endpoints' y al documento con el ID proporcionado
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('endpoints')
        .doc('Oho5WDEdQVsIxieL54Ox')
        .get();

    if (doc.exists) {
      // Obtén los campos 'calculateWather' y 'predictions'
      String get = doc.get('get');
      String post = doc.get('post');

      // Devuelve los valores como un mapa
      return {
        'get': get,
        'post': post,
      };
    } else {
      return {};
    }
  } catch (e) {
    return {};
  }
}

Future<Map<String, dynamic>> getService(String areaR, String monthR) async {

  //get url from firebase in endpoints
  Map<String, String> endpoints = await getEndpoints();
  String? calculateWatherUrl = endpoints['calculateWather'];

  // Crea una instancia de ApiService
  String? monthSring = monthNames[int.parse(monthR)];
  String product = 'product=papa';
  String area = 'area=$areaR';
  String month = 'month=$monthSring';

  String route = '$product&$area&$month';

  try {
    Map<String, dynamic> response = await ApiService.getData(route);
    return response;
  } catch (e) {
    return {};
  }
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
    final userCropsSnapshot =
        await collectionUsers.doc(me.id).collection('myCrops').get();

    // Si no hay documentos en la subcolección, también devuelve una lista vacía
    if (userCropsSnapshot.docs.isEmpty) {
      return [];
    }

    // Mapea los documentos de la subcolección a una lista
    final userCrops = userCropsSnapshot.docs.map((doc) => doc.data()).toList();
    return userCrops;
  } catch (e) {
    return [];
  }
}
