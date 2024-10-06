import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MyUser extends Equatable {
  String id;
  String name;

  MyUser(this.id, this.name);

  @override
  List<Object?> get props => [id];

  Map<String, Object?> toFirebaseMap(
      {String? newImage, String? newAdministrativeArea}) {
    return <String, Object?>{
      'id': id,
      'name': name,
    };
  }

  MyUser.fromFirebaseMap(Map<String, Object?> data)
      : id = data['id'] as String,
        name = data['name'] as String;
}
