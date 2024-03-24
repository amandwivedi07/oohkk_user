import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getitgouser/modules/auth/views/screens/login_screen.dart';
import 'package:getitgouser/modules/auth/views/screens/otp_verification.dart';
import 'package:getitgouser/shared/api/api_config.dart';
import 'package:getitgouser/shared/constants/string.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../../shared/api/base_provider.dart';

import '../../../shared/helper/di.dart';
import '../../../shared/helper/utils/helper.dart';
import '../models/user.dart' as app_user;
import 'package:geocoding/geocoding.dart' as geo;

class AuthController extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseRemoteConfig remoteConfig = Get.find();
  late String verificationId;
  Rx<app_user.User>? currentUser;

  bool showOnboarding = false;
  RxBool isInitialised = false.obs;

  late FirebaseMessaging _firebaseMessaging;
  String _fcmToken = '';

  late final String host;
  final box = Hive.box('secureBox');
  double? userCurrentLatitude, userCurrentLongitude;

  late List<geo.Placemark> placemark;
  String? address;

  @override
  void onInit() {
    super.onInit();
    _handleLocationPermission();
    getLocationUser();
    initializeFlow();
  }

  initializeFlow() async {
    // host =
    //     // "6f7a-2409-40f2-1039-da82-7884-c014-ab1c-f58c.ngrok-free.app";
    //     remoteConfig.getString('${DependencyInject.buildMode}_host');
    // debugPrint(host.toString());
    // _firebaseMessaging = fcmInstance;
    // debugPrint(currentUser.toString());
    getPermission();
    // if (box.get(HiveKeys.accessToken) != null &&
    //     box.get(HiveKeys.refreshToken) != null) {
    //   if (!isExpiredJWT(box.get(HiveKeys.refreshToken))) {
    //     await _setAuth(
    //         box.get(HiveKeys.accessToken), box.get(HiveKeys.refreshToken),
    //         putControllers: true,
    //         user: app_user.User.fromJson((box.get(HiveKeys.user))));
    //   }
    // } else {
    currentUser = null;
    // }
    // showOnboarding = !(box.get(HiveKeys.isOnboardingDirty) ?? false);
    // if (showOnboarding) {
    //   box.put(HiveKeys.isOnboardingDirty, true);
    // }
    // if (currentUser != null) {
    //   // await setupFcmToken();
    //   await refreshToken();
    // }
    isInitialised.value = true;
  }

  Future<void> setupFcmToken() async {
    // Get the token each time the application loads
    final token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    _fcmToken = token;
    if (currentUser != null) {
      final url = Config.updateFcm;
      await BaseHttpProvider().postRequest(url, {'fcmToken': token});
    }
  }

  Future<void> getPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _getFCMToken() async {
    String? token;
    if (kIsWeb) {
      token = await _firebaseMessaging.getToken(
          vapidKey: FirebaseConstants.firebaseValidKey);
    } else {
      token = await _firebaseMessaging.getToken();
    }
    if (token != null) {
      debugPrint("fcm token: $token");
      _fcmToken = token;
    }
  }

  Future<void> _setAuth(String access, String refresh,
      {bool putControllers = false, app_user.User? user}) async {
    try {
      Map decodedToken = JwtDecoder.decode(access);
      setUser(user ?? app_user.User.fromJson(Map.from(decodedToken)));
      await box.putAll({
        HiveKeys.accessToken: access,
        HiveKeys.refreshToken: refresh,
        HiveKeys.user: currentUser!.toJson(),
        HiveKeys.fcmToken: _fcmToken,
      });
      // if (putControllers) {
      //   Get.put(OrderController());
      //   Get.put(ListingController());
      //   Get.put(BidController());
      // }
    } on Exception catch (e) {
      e.printError();
      logout();
    }
  }

  Future<void> setUser(app_user.User user) async {
    currentUser == null ? currentUser = user.obs : currentUser!.value = user;
    await box.put(HiveKeys.user, currentUser!.toJson());
  }

  Future<http.Response> registerUser(Map body) async {
    try {
      final response =
          await BaseHttpProvider().putRequest(Config.registerEndpoints, body);
      _handleResponse(response);

      await setUser(
          app_user.User.fromJson({...currentUser!.value.toJson(), ...body}));
      debugPrint(response.toString());
      return response;
    } on Exception {
      debugPrint('register api fault');
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final accessToken = box.get(HiveKeys.accessToken);
      final refreshToken = box.get(HiveKeys.refreshToken);
      final Map<String, String> header = {
        'Authorization': 'Bearer $accessToken'
      };
      await _getFCMToken();
      final Map body = {'token': refreshToken};
      final url = Uri.https(host, Config.refreshEndpoints);
      final response = await http.post(url, body: body, headers: header);
      if (response.statusCode == 403) {
        throw response;
      }
      _handleResponse(response);
      final Map data = jsonDecode(response.body);
      await _setAuth(data['accessToken'], data['refreshToken']);
      return true;
    } on Exception catch (e) {
      e.printError();
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      Helper.showLoading('Logging out'.tr);
      final accessToken = box.get(HiveKeys.accessToken);
      final refreshToken = box.get(HiveKeys.refreshToken);
      if (accessToken == null || refreshToken == null) {
        Get.offAll(const LoginScreen());
      }
      await _auth.signOut();
      final url = Uri.https(host, Config.logutEndpoints);
      final headers = {"Authorization": "Bearer $accessToken"};
      http.Response response = await http.post(url,
          headers: headers,
          body: {'access': accessToken, 'refresh': refreshToken});
      _handleResponse(response);
      await box.deleteAll([
        HiveKeys.accessToken,
        HiveKeys.refreshToken,
        HiveKeys.user,
        HiveKeys.fcmToken
      ]);
      Helper.hideLoading();
      Get.offAll(const LoginScreen());
    } on Exception catch (e) {
      Helper.hideLoading();
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode >= 400) {
      debugPrint(response.body);
      throw Exception(response);
    }
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Body: ${response.body}');
    // debugPrint('AD');
    debugPrint('Response Code: ${response.statusCode}');
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    Helper.showLoading('Sending otp...'.tr);
    await _auth
        .verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await authenticate(credential.smsCode!);
        } on Exception catch (e) {
          e.printError();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        e.printError();
        Helper.hideLoading();
        Get.snackbar(
            'Error', 'verificationFailed'.trParams({'message': e.message!}));
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        Helper.hideLoading();

        Get.to(OtpVerificationView(
          phoneNumber: phoneNumber,
        ));
      },
      timeout: const Duration(seconds: 0),
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    )
        .onError((error, stackTrace) {
      error.printError();
    });
  }

  Future<app_user.User?> authenticate(String otp) async {
    try {
      Helper.showLoading('Logging you in...'.tr);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String jwtToken = await user.getIdToken() ?? '';
        debugPrint(jwtToken.toString());

        http.Response response = await http.post(
          Uri.https(host, Config.loginEndpoints),
          body: json.encode({"token": jwtToken}),
          headers: {"Content-Type": "application/json"},
        );
        debugPrint(response.statusCode.toString());
        if (response.statusCode >= 400) {
          await logout();
          Get.showSnackbar(GetSnackBar(
            title: "Error Signing in".tr,
            message: response.body,
          ));
          return null;
        }
        // curl -H "Content-Type: application/json" -X POST -d '{"user":"bob","pass":"123"}' http://URL/

        final data = jsonDecode(response.body);
        await _setAuth(data['accessToken'], data['refreshToken'],
            putControllers: true);
        // await setupFcmToken();
        print(currentUser!.value.toString());
        return currentUser!.value;
      }

      return null;
    } on Exception catch (e) {
      e.printError();
      Fluttertoast.showToast(msg: 'wrongOtpText'.tr);
    } finally {
      Helper.hideLoading();
    }
    return null;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      return false;
    }
    return true;
  }

  Future<Position> determinePosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      Fluttertoast.showToast(msg: "Enable location to select address".tr);
    }

    return await Geolocator.getCurrentPosition();
  }

  void getLocationUser() async {
    Position? position = await determinePosition();
    userCurrentLatitude = position.latitude;
    userCurrentLongitude = position.longitude;
    getAddress(userCurrentLatitude!, userCurrentLongitude!);
  }

  void getAddress(double latitude, double longitude) async {
    placemark = await placemarkFromCoordinates(latitude, longitude);
    address =
        "${placemark[0].name}, ${placemark[0].thoroughfare}, ${placemark[0].subLocality}, ${placemark[0].locality},${placemark[0].postalCode}";
  }
}
