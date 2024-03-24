import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneUtils {
  static Future<void> makePhoneCall(String phoneNumber) async {
    debugPrint(phoneNumber);
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
