//import '../../message/model/message.dart';
//import '../../profile/model/user.dart';

class Event {
  String id;
  String name;
  String description;
  double latitude;
  double longitude;
  DateTime dateTime;
  List members;
  //List<Message> messages;
  DateTime timeCreated;
  String admin;
  //List<MyUser> postulantes;

  Event(this.id, this.name, this.description, this.latitude, this.longitude, this.dateTime, this.members, this.timeCreated, this.admin);

  void addMember(String member){
    members.add(member);
  }

  // void addMessage(Message message){
  //   messages.add(message);
  // }

  void updateDateTime(DateTime newDate){
    dateTime = newDate;
  }

}