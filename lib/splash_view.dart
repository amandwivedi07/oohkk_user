import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getitgouser/modules/auth/controllers/auth_controller.dart';
import 'package:getitgouser/modules/auth/views/screens/login_screen.dart';
import 'package:getitgouser/modules/auth/views/screens/signup_screen.dart';
import 'package:getitgouser/modules/home/view/home_view.dart';
import 'package:getitgouser/modules/onboarding/views/Screens/onboarding_screen.dart';
import 'package:getitgouser/shared/constants/assets.dart';
import 'package:getitgouser/shared/constants/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _controller = Get.find<AuthController>();

  RemoteMessage? initialMessage;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const LoginScreen());
    });

    super.initState();
  }

  // Future<void> setUpInteractedMessage() async {
  //   initialMessage = await FirebaseMsessaging.instance.getInitialMessage();
  //   if (initialMessage != null) {
  //     handleNotificationTap(initialMessage!);
  //   }

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     showFlutterNotification(message);
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   setUpInteractedMessage();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              image: DecorationImage(
                image: AssetImage(Assets.background),
                fit: BoxFit.fill,
              )),
          child: SizedBox(
            child: const Text('Splash Screen'),
            // child: Image.asset(
            //   Assets.splashLogo,
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ),
    );
    Scaffold(body: Obx(() {
      if (_controller.isInitialised.isTrue) {
        if (_controller.currentUser != null) {
          if (_controller.currentUser!.value.name == null) {
            return const SignUpScreen();
          }
          return const HomeView();
        }
        if (_controller.showOnboarding) {
          return const OnboardingView();
        }
        if (_controller.currentUser == null) {
          return const LoginScreen();
        }
      }
      return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                image: DecorationImage(
                  image: AssetImage(Assets.background),
                  fit: BoxFit.fill,
                )),
            child: SizedBox(
              child: const Text('Splash'),
              // child: Image.asset(
              //   Assets.splashLogo,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        ),
      );
    }));

    //   SafeArea(
    //     child: Container(
    //       alignment: Alignment.center,
    //       // decoration: const BoxDecoration(
    //       //     color: AppColors.whiteColor,
    //       //     image: DecorationImage(
    //       //       image: AssetImage(Assets.background),
    //       //       fit: BoxFit.fill,
    //       //     )),
    //       child: const SizedBox(child: Text('Splash Screen')
    //           //  Image.asset(
    // Assets.splashLogo,
    //           //   fit: BoxFit.cover,
    //           // ),
    //           ),
    //     ),
    //   ),
    // );
  }
}
