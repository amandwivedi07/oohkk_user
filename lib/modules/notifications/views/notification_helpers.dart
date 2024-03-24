// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';

// import 'package:getitgouser/modules/notifications/controllers/notifications_controller.dart';
// import 'package:getitgouser/shared/constants/string.dart';

// class NotificationInitialization {
//   // / Create a [AndroidNotificationChannel]
//   late AndroidNotificationChannel channel;

//   late final RemoteMessage? message;

//   /// Initialize the [FlutterLocalNotificationsPlugin]
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   late final FirebaseMessaging fcmInstance;

//   bool isFlutterLocalNotificationsInitialized = false;

//   handleNotificationResponse(NotificationResponse response) {
//     NotificationController.handleTapAction(
//         jsonDecode(response.payload ?? '{}'));
//   }

//   Future<void> setupFlutterNotifications() async {
//     if (isFlutterLocalNotificationsInitialized) {
//       return;
//     }
//     channel = AndroidNotificationChannel(
//       FirebaseConstants.firebaseId, // id
//       FirebaseConstants.firebaseTitle, // title
//       description: FirebaseConstants.firebaseDescription, // description
//       importance: Importance.high,
//     );

//     const InitializationSettings initSettings = InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/launcher_icon'),
//         iOS: DarwinInitializationSettings());

//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//     /// on did receive notification response = for when app is opened via notification while in foreground on android
//     await flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: handleNotificationResponse);

//     /// Create an Android Notification Channel.
//     ///
//     /// We use this channel in the `AndroidManifest.xml` file to override the
//     /// default FCM channel to enable heads up notifications.
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();

//     /// need this for ios foregournd notification
//     await fcmInstance.setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//     isFlutterLocalNotificationsInitialized = true;
//   }

//   void showFlutterNotification(
//     RemoteMessage message,
//   ) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null && !kIsWeb) {
//       if (["/PaymentProcessing", "/CustomWebView", "/ListingDetails"]
//           .contains(Get.currentRoute)) {
//         NotificationController.handleTapAction(message.data, true);
//       }
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(channel.id, channel.name,
//               channelDescription: channel.description,
//               icon: '@mipmap/launcher_icon',
//               visibility: NotificationVisibility.public),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     }
//   }

//   void handleNotificationTap(RemoteMessage message) async {
//     await NotificationController.handleTapAction(message.data);
//   }

//   @pragma('vm:entry-point')
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await setupFlutterNotifications();
//     showFlutterNotification(message);
//     debugPrint('Handling a background message ${message.messageId}');
//   }

//   Future<void> initFCM() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     fcmInstance = FirebaseMessaging.instance;
//     if (!kIsWeb) {
//       await setupFlutterNotifications();
//     }
//     message = await fcmInstance.getInitialMessage();
//   }
// }
