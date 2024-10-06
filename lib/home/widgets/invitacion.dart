// import 'package:investi_go/login/widgets/glassmorphic_box.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';

// import '../../message/view/chat_screen.dart';
// import '../../profile/view/profile_image_screen.dart';
// import '../../settings/provider/location.dart';
// import '../provider/cloud_firestore.dart';
// import '../view/main_screen.dart';

// class Invitacion extends StatefulWidget {
//   final String idE;
//   final String name;
//   final String description;
//   final String? imageURL;
//   final double? latitude;
//   final double? longitude;
//   final DateTime date;
//   final List members;
//   final List? interests;
//   final String type;
//   final Widget boton;

//   const Invitacion({
//     super.key,
//     required this.idE,
//     required this.name,
//     required this.description,
//     required this.imageURL,
//     required this.latitude,
//     required this.longitude,
//     required this.date,
//     required this.members,
//     required this.interests,
//     required this.type,
//     required this.boton,
//   });

//   @override
//   State<Invitacion> createState() => _InvitacionState();
// }

// class _InvitacionState extends State<Invitacion> {
//   HomeFirestore fire = HomeFirestore();
//   double myLat = locationData.latitude ?? 2.585;
//   double myLon = locationData.longitude ?? 2.5;

//   String distanciaOVirtual() {
//     if (widget.latitude == null || widget.longitude == null) {
//       return 'Encuentro Virtual';
//     } else {
//       double distancia = fire.distanciaCoordenadas(
//           widget.latitude!, widget.longitude!, myLat, myLon);
//       return distancia.round() > 0
//           ? 'A ${distancia.round()} km'
//           : 'A menos de 1 km';
//     }
//   }

//   String formatDateTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final difference = dateTime.difference(today).inDays;

//     if (difference == 0) {
//       return 'hoy';
//     } else if (difference == 1) {
//       return 'mañana';
//     } else if (difference == -1) {
//       return 'ayer';
//     } else if (difference > 1 && difference <= 7) {
//       switch (dateTime.weekday) {
//         case DateTime.monday:
//           return 'próximo lunes';
//         case DateTime.tuesday:
//           return 'próximo martes';
//         case DateTime.wednesday:
//           return 'próximo miércoles';
//         case DateTime.thursday:
//           return 'próximo jueves';
//         case DateTime.friday:
//           return 'próximo viernes';
//         case DateTime.saturday:
//           return 'próximo sábado';
//         case DateTime.sunday:
//           return 'próximo domingo';
//         default:
//           return '';
//       }
//     } else {
//       return '${dateTime.day} / ${dateTime.month}';
//     }
//   }

//   List<Widget> fotos(
//     List members,
//   ) {
//     List<Widget> fotos = [];

//     for (var member in members) {
//       if (member['image'] != null) {
//         fotos.add(GestureDetector(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ImageScreen(
//                         name: member['name'],
//                         imageUrl: member['image'],
//                         description: member['description'],
//                         interests: member['interests'],
//                         birthdate: member['birthdate'].toDate())));
//           },
//           child: SizedBox(
//             width: 70,
//             height: 70,
//             child: ClipOval(
//                 child: Image.network(
//               member['image'],
//               fit: BoxFit.cover,
//             )),
//           ),
//         ));
//       }
//     }
//     return fotos;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String imageAssets;
//     switch (widget.type) {
//       case 'Trabajo':
//         imageAssets = 'assets/TypeWork.jpg';
//         break;
//       case 'Diversion':
//         imageAssets = 'assets/TypeFunny.jpg';
//         break;
//       case 'Deporte':
//         imageAssets = 'assets/TypeSport.jpg';
//         break;
//       case 'Estudio':
//         imageAssets = 'assets/TypeStudy.jpg';
//         break;
//       case 'Proyectos':
//         imageAssets = 'assets/TypeProjects.jpg';
//         break;
//       default:
//         imageAssets = 'assets/TypeDefault.jpg';
//         break;
//     }
//     final image = widget.imageURL != null
//         ? NetworkImage(widget.imageURL!)
//         : AssetImage(imageAssets);
//     return Container(
//       constraints: const BoxConstraints(
//         minHeight: 270,
//       ),
//       margin: const EdgeInsets.only(top: 50, left: 8, right: 8, bottom: 1),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           width: 2,
//           color: Colors.white70,
//         ),
//         image: DecorationImage(
//           image: image as ImageProvider,
//           fit: BoxFit.cover,
//           alignment: Alignment.center,
//           colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.9), BlendMode.dstATop),
//         ),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 80,
//                     padding: const EdgeInsets.all(5),
//                     child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children: fotos(widget.members)),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     '${widget.members.length}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 7.0,
//                           color: Colors.black,
//                           offset: Offset(2.0, 2.0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Text(widget.name,
//                   style: const TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 7.0,
//                         color: Colors.black,
//                         offset: Offset(2.0, 4.0),
//                       ),
//                     ],
//                   )),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Text(widget.description,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 19,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 7.0,
//                         color: Colors.black,
//                         offset: Offset(2.0, 4.0),
//                       ),
//                     ],
//                   )),
//             ),
//             const SizedBox(height: 10.0),
//             if (widget.interests != null && widget.interests!.isNotEmpty)
//               Center(
//                 child: Wrap(
//                   spacing: 3.0,
//                   children: widget.interests!.map((e) {
//                     if (tagsPago.contains(e)) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 8, horizontal: 1),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(14.0),
//                             image: const DecorationImage(
//                                 image: AssetImage('assets/premium.gif'),
//                                 fit: BoxFit.cover)),
//                         child: Text(e,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                             )),
//                       );
//                     } else {
//                       return Chip(
//                           label: Text(e),
//                           labelStyle: const TextStyle(
//                               color: Colors.white, fontSize: 11),
//                           backgroundColor: Colors.blue);
//                     }
//                   }).toList(),
//                 ),
//               ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       distanciaOVirtual(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.white,
//                         shadows: [
//                           Shadow(
//                             blurRadius: 7.0,
//                             color: Colors.black,
//                             offset: Offset(2.0, 4.0),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                         '${formatDateTime(widget.date)}\n${DateFormat.jm().format(widget.date)}',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17,
//                             color: Colors.white,
//                             shadows: [
//                               Shadow(
//                                 blurRadius: 7.0,
//                                 color: Colors.black,
//                                 offset: Offset(2.0, 4.0),
//                               ),
//                             ]))
//                   ]),
//             ),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GlassBox(
//                     onTap: () {
//                       Share.share(
//                           'Mira este evento: \n https://eventmatch-a3159.firebaseapp.com/event/${widget.idE}');
//                     },
//                     child:
//                         const Icon(Icons.share, color: Colors.white, size: 30),
//                   ),
//                 ),
//                 Expanded(child: widget.boton),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class BotonDinamico extends StatefulWidget {
//   String idE;
//   String condicion;
//   String name;
//   String description;
//   String formatDate;
//   DateTime date;
//   List members;
//   bool isJoined;

//   BotonDinamico(this.idE, this.condicion, this.name, this.description,
//       this.formatDate, this.date, this.members,
//       {this.isJoined = false, super.key});

//   @override
//   State<BotonDinamico> createState() => _BotonDinamicoState();
// }

// class _BotonDinamicoState extends State<BotonDinamico> {
//   HomeFirestore fire = HomeFirestore();
//   Widget texto = const Text(
//     'Unirse',
//   );
//   bool isSended = false;
//   // CountState countState = CountState();

//   @override
//   Widget build(BuildContext context) {
//     if (widget.isJoined || isSended) {
//       texto = const Text(
//         'Ya estas dentro',
//         style: TextStyle(
//             color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//       );
//     } else {
//       texto = const Text(
//         'Unirse',
//         style: TextStyle(
//           color: Colors.green,
//           fontSize: 25,
//           fontWeight: FontWeight.bold,
//           shadows: [
//             Shadow(
//               blurRadius: 10.0,
//               color: Colors.black,
//               offset: Offset(5.0, 5.0),
//             ),
//           ],
//         ),
//       );
//     }
//     return GlassBox(
//       onTap: (widget.isJoined || (isSended && count > 0))
//           ? null
//           : () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) => CupertinoAlertDialog(
//                   title: const Text(
//                     'Condiciones y Requisitos',
//                   ),
//                   content: Text(widget.condicion),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(
//                         context,
//                       ),
//                       child: const Text(
//                         'cancelar',
//                       ),
//                     ),
//                     if (count > 0)
//                       ElevatedButton(
//                           onPressed: () {
//                             count = count - 1;
//                             setState(() {
//                               isSended = true;
//                             });
//                             fire
//                                 .sendIdEventToIAm(widget.idE, widget.name,
//                                     widget.description, widget.date, count)
//                                 .then((value) {
//                               countStreamController!.add(count);
//                               Navigator.pop(context);
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => ChatScreen(
//                                             widget.idE,
//                                             widget.name,
//                                           )));
//                             });
//                           },
//                           child: const Text('SUENA BIEN')),
//                   ],
//                 ),
//               );
//             },
//       child: texto,
//     );
//   }
// }

// // ignore: must_be_immutable
// class BotonDinamicoDelete extends StatefulWidget {
//   String idE;
//   BotonDinamicoDelete(this.idE, {super.key});

//   @override
//   State<BotonDinamicoDelete> createState() => _BotonDinamicoDeleteState();
// }

// class _BotonDinamicoDeleteState extends State<BotonDinamicoDelete> {
//   HomeFirestore fire = HomeFirestore();
//   bool tap = false;

//   @override
//   Widget build(BuildContext context) {
//     return GlassBox(
//         child: tap
//             ? const Text('eliminado')
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Mi evento'),
//                   IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) => CupertinoAlertDialog(
//                           title: const Text(
//                               'Seguro que quieres eliminar este evento?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(
//                                 context,
//                               ),
//                               child: const Text('cancelar'),
//                             ),
//                             ElevatedButton(
//                                 onPressed: () {
//                                   fire.deleteEvent(widget.idE);
//                                   setState(() {
//                                     tap = true;
//                                   });
//                                   Navigator.pop(context);
//                                 },
//                                 child: const Text('Si')),
//                           ],
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                   ),
//                 ],
//               ));
//   }
// }
