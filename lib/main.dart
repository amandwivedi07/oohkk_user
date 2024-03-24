import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:getitgouser/modules/auth/views/screens/otp_verification.dart';
import 'package:getitgouser/modules/home/view/home_view.dart';
import 'package:getitgouser/modules/notifications/controllers/notifications_controller.dart';
import 'package:getitgouser/shared/constants/color.dart';
import 'package:getitgouser/shared/constants/font_family.dart';
import 'package:getitgouser/shared/constants/string.dart';
import 'package:getitgouser/shared/helper/di.dart';
import 'package:getitgouser/splash_view.dart';

Future<void> initFCM() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  fcmInstance = FirebaseMessaging.instance;
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  message = await fcmInstance.getInitialMessage();
}

final NotificationController notificationController = Get.find();
late final FirebaseMessaging fcmInstance;
late final RemoteMessage? message;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  debugPrint('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel]
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

handleNotificationResponse(NotificationResponse response) {
  NotificationController.handleTapAction(jsonDecode(response.payload ?? '{}'));
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = AndroidNotificationChannel(
    FirebaseConstants.firebaseId, // id
    FirebaseConstants.firebaseTitle, // title
    description: FirebaseConstants.firebaseDescription, // description
    importance: Importance.high,
  );

  const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings());

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// on did receive notification response = for when app is opened via notification while in foreground on android
  await flutterLocalNotificationsPlugin.initialize(initSettings,
      onDidReceiveNotificationResponse: handleNotificationResponse);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  /// need this for ios foregournd notification
  await fcmInstance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(
  RemoteMessage message,
) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null && !kIsWeb) {
    if (["/PaymentProcessing", "/CustomWebView", "/ListingDetails"]
        .contains(Get.currentRoute)) {
      NotificationController.handleTapAction(message.data, true);
    }
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/launcher_icon',
            visibility: NotificationVisibility.public),
      ),
      payload: jsonEncode(message.data),
    );
  }
}

void handleNotificationTap(RemoteMessage message) async {
  await NotificationController.handleTapAction(message.data);
}

/// Initialize the [FlutterLocalNotificationsPlugin]
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future main() async {
  await DependencyInject().init();
  runApp(const MyApp());
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        appBarTheme: AppBarTheme(
          actionsIconTheme: const IconThemeData(color: AppColors.blackColor),
          backgroundColor: AppColors.whiteColor,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: kManropeSemiBold.copyWith(
            color: AppColors.blackColor,
            fontSize: kFont17,
            letterSpacing: -0.41,
          ),
        ),
      ),
      home: const SplashScreen(),

      //  const SplashScreen(),
      enableLog: false,
      title: 'Oohhkk',
    );
  }
}
