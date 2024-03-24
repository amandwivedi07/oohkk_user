import 'dart:convert';

import 'package:get/get.dart';
import 'package:getitgouser/modules/notifications/model/notification_model.dart';
import 'package:getitgouser/shared/api/api_config.dart';
import 'package:http/http.dart' as http;

import '../../../shared/api/base_provider.dart';

class NotificationController extends GetxController {
  static Future<void> handleTapAction(Map data, [bool? isStateUpdate]) async {
    String route = data['route'];
    // if (route == '/payment_status' &&
    //     ["/PaymentProcessing", "/CustomWebView"].contains(Get.currentRoute)) {
    //   Get.off(() => PaymentStatus(payment: jsonDecode(data['payment'])));
    //   return;
    // }
    // if (route == '/listing') {
    //   String listingId = data['listingId'];
    //   if (Get.currentRoute == '/ListingDetails' &&
    //       currentListingId == listingId) {
    //     Get.off(() => ListingDetails(listingId: listingId),
    //         preventDuplicates: false);
    //   } else if (!(isStateUpdate ?? false)) {
    //     Get.to(() => ListingDetails(listingId: listingId),
    //         preventDuplicates: false);
    //   }
    // }
  }

  static Future<List<NotificationModel>> get() async {
    try {
      http.Response response = await BaseHttpProvider()
          .getRequest(Config.fetchNotificationsEndpoint);
      return notificationsFromJson(response.body);
    } catch (e) {
      e.printError();
      rethrow;
    }
  }
}
