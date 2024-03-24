import 'dart:convert';

List<NotificationModel> notificationsFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

class NotificationModel {
  final String id;
  final String token;
  final Notification notification;
  final Data? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.token,
    required this.notification,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      token: json['token'],
      notification: Notification.fromJson(json['notification']),
      data: json['data'] == null ? null : Data.fromJson(json['data']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Notification {
  final String title;
  final String body;

  Notification({
    required this.title,
    required this.body,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'],
      body: json['body'],
    );
  }
}

class Data {
  final String? route;
  final String? listingId;

  Data({
    this.route,
    this.listingId,
  });

  toJson() => {
        'route': route,
        'listingId': listingId,
      };

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      route: json['route'],
      listingId: json['listingId'],
    );
  }
}
