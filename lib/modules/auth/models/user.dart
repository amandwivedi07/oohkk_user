// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String? id;
  String phone;
  String? name;
  bool active;
  String? uid;
  String? firebaseUserId;
  String? defaultLanguage;

  User({
    this.id,
    required this.phone,
    this.name,
    required this.active,
    this.uid,
    this.firebaseUserId,
    this.defaultLanguage,
  });

  factory User.fromJson(json) {
    return User(
        id: json["_id"],
        phone: json["phone"],
        name: json["name"],
        active: json["active"],
        uid: json["uid"],
        firebaseUserId: json["firebase_user_id"],
        defaultLanguage: json["language"]);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "name": name,
        "active": active,
        "uid": uid,
        "firebase_user_id": firebaseUserId,
      };
}

// List<City> cityFromJson(String str) =>
//     List<City>.from(json.decode(str).map((x) => City.fromJson(x)));

// String cityToJson(List<City> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class City {
//   final String id;
//   final Location location;
//   final bool active;
//   final String displayName;
//   final String name;
//   final String state;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   City({
//     required this.id,
//     required this.location,
//     required this.active,
//     required this.displayName,
//     required this.name,
//     required this.state,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory City.fromJson(Map<String, dynamic> json) => City(
//         id: json["_id"],
//         location: Location.fromJson(json["location"]),
//         active: json["active"],
//         displayName: json["display_name"],
//         name: json["name"],
//         state: json["state"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//       );

//   static List<City> fromList(List json) => json
//       .map(
//         (e) => City.fromJson(e),
//       )
//       .toList();

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "location": location.toJson(),
//         "active": active,
//         "display_name": displayName,
//         "name": name,
//         "state": state,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//       };
// }

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
