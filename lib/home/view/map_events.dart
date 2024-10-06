// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eventmatch/home/widgets/invitacion.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// // ignore: depend_on_referenced_packages
// import 'package:latlong2/latlong.dart';
// import '../../message/view/message_body.dart';
// import '../../settings/provider/location.dart';
// import '../provider/cloud_firestore.dart';
// import 'main_screen.dart';

// class MapEvent extends StatefulWidget {
//   const MapEvent({super.key});
//   @override
//   State<MapEvent> createState() => _MapEventState();
// }

// class _MapEventState extends State<MapEvent> {
//   final PageController _pageController = PageController();
//   final mapboxAccessToken =
//       'pk.eyJ1IjoiY3Jpc21hY2giLCJhIjoiY2xleWlsaHdiMHd1MjN3bXpnZmN6MG51byJ9.FWNvFwVTWSqqmcbs3ecQiQ';
//   final mapboxStyle = 'mapbox/streets-v12';
//   final LatLng _myLocation =
//       LatLng(locationData.latitude!, locationData.longitude!);
//   List<Map> events = [];
//   HomeFirestore fire = HomeFirestore();

//   List<Marker> _buildMarkers(List<Map> events) {
//     List<Marker> listMarkers = [];
//     for (var event in events) {
//       Icon icon;
//       switch (event['type']) {
//         case 'Estudio':
//           icon = const Icon(Icons.book, color: Colors.red);
//           break;
//         case 'Deporte':
//           icon = const Icon(Icons.sports_soccer, color: Colors.orange);
//           break;
//         case 'Diversion':
//           icon = const Icon(Icons.sports_bar, color: Colors.yellowAccent);
//           break;
//         case 'Proyectos':
//           icon = const Icon(Icons.rocket_launch, color: Colors.blue);
//           break;
//         default:
//           icon = const Icon(Icons.location_on, color: Colors.purple);
//       }
//       listMarkers.add(
//         Marker(
//             point: LatLng(event['latitude'], event['longitude']),
//             builder: (context) {
//               return GestureDetector(
//                 onTap: () {
//                   _pageController.animateToPage(events.indexOf(event),
//                       duration: const Duration(microseconds: 500),
//                       curve: Curves.elasticInOut);
//                 },
//                 child: icon,
//               );
//             }),
//       );
//     }
//     return listMarkers;
//   }

//   Future<List<Map>> getEventsDocs() async {
//     List<Map> events2 = [];
//     List<DocumentSnapshot> eventsDoc = await fire.getEventsFilterGeoHashAll(
//         locationData.latitude!, locationData.longitude!);
//     for (var doc in eventsDoc) {
//       Map event = doc.data() as Map;
//       events2.add(event);
//     }
//     return events2;
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   bool imEnter(List members) {
//     bool enter = false;
//     for (var i in members) {
//       if (i['id'] == me.id) {
//         enter = true;
//         break;
//       }
//     }
//     return enter;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Eventos'),
//         backgroundColor: Colors.black,
//       ),
//       body: FutureBuilder<Object>(
//           future: getEventsDocs(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               events = snapshot.data as List<Map>;
//               List<Marker> markers = _buildMarkers(events);
//               return Stack(
//                 children: [
//                   FlutterMap(
//                     options: MapOptions(
//                       minZoom: 5,
//                       maxZoom: 16,
//                       zoom: 13,
//                       center: _myLocation,
//                     ),
//                     nonRotatedChildren: [
//                       TileLayer(
//                         urlTemplate:
//                             'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
//                         additionalOptions: {
//                           'accessToken': mapboxAccessToken,
//                           'id': mapboxStyle,
//                         },
//                       ),
//                       MarkerLayer(
//                         markers: markers,
//                       ),
//                       MarkerLayer(markers: [
//                         Marker(
//                           height: 5,
//                           width: 5,
//                           point: _myLocation,
//                           builder: (_) {
//                             return const Icon(Icons.circle_outlined,
//                                 color: Colors.blueAccent);
//                           },
//                         ),
//                       ]),
//                     ],
//                   ),
//                   if (events.isNotEmpty)
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       top: -19,
//                       height: 350,
//                       child: PageView.builder(
//                         controller: _pageController,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: ((context, index) {
//                           final event = events[index];
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 12.0),
//                             child: Invitacion(
//                               idE: event['id'],
//                               name: event['name'],
//                               description: event['description'],
//                               imageURL: event['imageURL'],
//                               latitude: event['latitude'],
//                               longitude: event['longitude'],
//                               date: event['date'].toDate(),
//                               members: event['members'],
//                               interests: event['interests'],
//                               type: event['type'],
//                               boton: BotonDinamico(
//                                 event['id'],
//                                 event['condicion'],
//                                 event['name'],
//                                 event['description'],
//                                 formatDateTime(event['date'].toDate()),
//                                 event['date'].toDate(),
//                                 event['members'],
//                                 isJoined: imEnter(event['members']),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                 ],
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           }),
//     );
//   }
// }
