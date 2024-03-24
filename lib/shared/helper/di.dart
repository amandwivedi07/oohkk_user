import 'dart:convert';
import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getitgouser/shared/helper/utils/device/device_utils.dart';
import 'package:getitgouser/shared/helper/widgets/upgrade_alert.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../firebase_options.dart';
import '../../main.dart';
import '../../modules/auth/controllers/auth_controller.dart';

class DependencyInject {
  static const String buildMode =
      String.fromEnvironment('BUILD_MODE', defaultValue: 'dev');

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      androidProvider: buildMode == 'dev'
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider:
          buildMode == 'dev' ? AppleProvider.debug : AppleProvider.deviceCheck,
    );
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await Hive.initFlutter();
    await Hive.openBox('secureBox');
    await DeviceUtils().setPreferredOrientations();
    // await initFCM();

    await _setupRemoteConfig();
    Get.put(AuthController());
  }

  startUpdateDaemon(
      int minRecommendedBuild, int obsoleteBuild, String updateInfo) async {
    await Future.delayed(const Duration(seconds: 2));
    if (Platform.isAndroid) {
      await InAppUpdate.checkForUpdate();
    }
    if (updateInfo != "") {
      UpgradeAlert.handleUpdate(
          minRecommendedBuild, obsoleteBuild, jsonDecode(updateInfo));
    }
  }

  Future<void> _setupRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 60),
          minimumFetchInterval: const Duration(hours: 1)));
      await remoteConfig.fetch();
      await remoteConfig.activate();
      startUpdateDaemon(
          remoteConfig.getInt('${buildMode}_minRecommendedBuild'),
          remoteConfig.getInt('${buildMode}_obsoleteBuild'),
          remoteConfig.getValue('${buildMode}_updateInfo').asString());
    } catch (e) {
      debugPrint('Failed to initialize remote config: $e');
      Fluttertoast.showToast(
          msg: 'Something went wrong, please try again later');
      rethrow;
    }

    // Register RemoteConfig instance to GetIt
    Get.put(remoteConfig);
  }
}
