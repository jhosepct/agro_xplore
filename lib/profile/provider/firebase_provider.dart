import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/view/main_screen.dart';
import '../../profile/model/user.dart';
// ignore: depend_on_referenced_packages

class FirebaseProvider {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated Exception');
    return user;
  }

  Future<MyUser?> getMyUser() async {
    final snapshot = await firestore.doc('users/${currentUser.uid}').get();
    if (snapshot.exists) return MyUser.fromFirebaseMap(snapshot.data()!);
    return null;
  }

  Future<void> saveMyUser(MyUser user) async {
    final ref = firestore.doc('users/${currentUser.uid}');
    await ref.set(user.toFirebaseMap(), SetOptions(merge: true));
  }

  Future<void> updateMyUser(String description, List interests) async {
    final ref = firestore.doc('users/${currentUser.uid}');
    await ref.update({
      'description': description,
      'interests': interests,
    });
  }

  Future<void> eliminarCuenta() async {
    await FirebaseFirestore.instance.collection('users').doc(me.id).delete();
  }
}
