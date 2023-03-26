// To parse this JSON data, do
//
//     final buyerModel = buyerModelFromJson(jsonString);

import 'dart:convert';

BuyerModel buyerModelFromJson(String str) =>
    BuyerModel.fromJson(json.decode(str));

Map<String, dynamic> buyerModelToJson(BuyerModel data) => data.toJson();

class BuyerModel {
  BuyerModel({
    this.id = 0,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory BuyerModel.fromJson(Map<String, dynamic> json) => BuyerModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address
      };

  @override
  String toString() => jsonEncode({
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      });
}
