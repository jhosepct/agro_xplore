// // import 'package:eventmatch/message/view/chat_screen.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// // import '../../app/view/app.dart';
// import '../view/main_screen.dart';
// import 'cloud_firestore.dart';

// // Future<void> handleBackgroundMessage(RemoteMessage message) async {
// //   // print('TTTTTTTTTTTTTTTTTTTTitle: ${message.notification?.title}');
// //   messagesStreamController.add(newMessagesGlobal++);
// //   // print('YA SE SUMO UN MENSAJE GLOBAL: $newMessagesGlobal');
// // }

// class PushNotification {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   BuildContext context;
//   PushNotification(this.context);

//   initNotification() {
//     messaging.requestPermission();
//     messaging.getToken().then((token) {
//       if (me.token != token) {
//         me.token = token;
//         updateToken(token!);
//       }
//     });
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     initForegroundPushNotifications();
//   }

//   // // Configuración del manejador de notificaciones cuando la app está en primer plano
//   //   messaging.onMessage.listen((RemoteMessage message) {
//   //     print("onMessage: $message");
//   //     _showNotificationDialog(context, message);
//   //   });

//   // function to initialize foreground settings
//   Future initForegroundPushNotifications() async {
//     // attach event listener for when the app is in the foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // print('Got a message whilst in the foreground!');

//       // print('Message data: ${message.data}');
//       _showNotificationDialog(context, message);
//       if (message.notification != null) {
//         // meter el local notification TODOOOOOOO
//         // print('Message also contained a notification: ${message.notification}');
//       }
//     });
//   }

//   // Método para mostrar una ventana emergente cuando la app está en primer plano
//   void _showNotificationDialog(BuildContext context, RemoteMessage message) {
//     messagesStreamController.add(newMessagesGlobal++);
//     // print('YA SE SUMO UN MENSAJE GLOBAL: $newMessagesGlobal');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: RichText(
//             text: TextSpan(children: [
//           TextSpan(
//               text: '${message.notification?.title}: ',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               )),
//           TextSpan(
//               text: message.notification?.body ?? 'Mensaje vacío',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//               )),
//         ])),
//       ),
//     );
//   }

//   // void handleMessage(RemoteMessage? message) {
//   //   // if teh message is null, do nothing
//   //   if (message == null) return;
//   //   // navigate to the chat screen when mesaage in received and user taps on it
//   //   navigatorKey.currentState!.push(
//   //     MaterialPageRoute(
//   //       builder: (context) => ChatScreen(
//   //         message.data['idEvent'],
//   //         message.data['nameEvent'],
//   //       ),
//   //     ),
//   //   );
//   // }

//   // // function to initialize backound settings
//   // Future initPushNotifications() async {
//   //   // handle notifications when the app was terminated and now opened
//   //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//   //   // attach event listener for when a notification opens the app
//   //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   // }
// }
