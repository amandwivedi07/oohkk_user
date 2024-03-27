import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart' as get_x;
import 'package:getitgouser/modules/auth/controllers/auth_controller.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constants/constant.dart';

class BaseHttpProvider {
  final box = Hive.box('secureBox');
  AuthController authController = get_x.Get.find();
  FirebaseRemoteConfig remoteConfig = get_x.Get.find();
  late String host;

  BaseHttpProvider._();
  static final _instance = BaseHttpProvider._();
  factory BaseHttpProvider() {
    // getitgo-backend-3zbd3vwdyq-el.a.run.app/api#/
    _instance.host = 'https://getitgo-backend-2cgarfqx4a-el.a.run.app';

    // _instance.host =
    //     _instance.remoteConfig.getString('${DependencyInject.buildMode}_host');
    return _instance;
  }

  Future<Response> getRequest(String endPoint,
      {Map<String, dynamic> newHeaders = const {},
      Map<String, dynamic>? queryParameters = const {}}) async {
    try {
      final url = Uri.https(host, endPoint, queryParameters);

      final headers = await _createHeaders(newHeaders);

      final response = await get(url, headers: {...headers, ...newHeaders});

      _handleResponse(response);

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Response> postRequest(String endPoint, Map body,
      {Map<String, dynamic> newHeaders = const {},
      Map<String, dynamic>? queryParameters}) async {
    try {
      final url = Uri.https(host, endPoint, queryParameters);
      log(url.toString());
      final headers = await _createHeaders(newHeaders);
      Map data = {};
      body.forEach((key, value) {
        data.addIf(value != null, key, value);
      });
      debugPrint(body.toString());

      final response = await post(url, body: json.encode(data), headers: {
        ...headers,
        ...newHeaders,
      });

      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Response> deleteRequest(String endPoint,
      {Map body = const {},
      Map<String, dynamic> newHeaders = const {},
      Map<String, dynamic>? queryParameters}) async {
    try {
      final url = Uri.https(host, endPoint, queryParameters);
      log(url.toString());
      final headers = await _createHeaders(newHeaders);
      Map data = {};
      body.forEach((key, value) {
        data.addIf(value != null, key, value);
      });
      debugPrint(body.toString());

      final response = await delete(url, body: json.encode(data), headers: {
        ...headers,
        ...newHeaders,
      });

      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Response> putRequest(String endPoint, Map body,
      {Map<String, dynamic> newHeaders = const {},
      Map<String, dynamic>? queryParameters}) async {
    try {
      final url = Uri.https(host, endPoint, queryParameters);
      log(url.toString());
      final headers = await _createHeaders(newHeaders);
      Map data = {};
      body.forEach((key, value) {
        data.addIf(value != null, key, value);
      });
      debugPrint(body.toString());

      final response = await put(url, body: json.encode(data), headers: {
        ...headers,
        ...newHeaders,
      });

      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, String>> _createHeaders(
      Map<String, dynamic> newHeaders) async {
    if (newHeaders['by-pass'] != null) {
      return {'content-type': 'application/json'};
    }
    final storedAccessToken = box.get(HiveKeys.accessToken);

    if (storedAccessToken != null) {
      if (isExpiredJWT(storedAccessToken)) {
        final bool logoutCheck = await authController.refreshToken();

        if (!logoutCheck) {
          authController.logout();
          throw Exception('logging user out :');
        }
        return _createHeaders(newHeaders);
      }
      Map<String, String> finalHeaders = {
        "Authorization": "Bearer $storedAccessToken"
      };
      if (newHeaders['content-type'] == null) {
        finalHeaders['content-type'] = 'application/json';
      }
      return finalHeaders;
    } else {
      authController.logout();
      throw Exception('Application logged out:');
    }
  }

  void _handleResponse(Response response) {
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Body: ${response.body}');

    if (response.statusCode >= 400) {
      throw Exception(response);
    }
  }
}

bool isExpiredJWT(String jwtToken) {
  final payload = JwtDecoder.decode(jwtToken);
  final int expiryTimeInMilliSeconds = payload['exp'];

  final bool validJWT = checkExpiry(expiryTimeInMilliSeconds);
  return validJWT;
}

bool checkExpiry(int expiryTimeInMs) {
  final DateTime currentTime = DateTime.now();
  DateTime expiryTime =
      DateTime.fromMillisecondsSinceEpoch(expiryTimeInMs * 1000);
  expiryTime = expiryTime.subtract(const Duration(minutes: 5));
  return currentTime.isAfter(expiryTime);
}
