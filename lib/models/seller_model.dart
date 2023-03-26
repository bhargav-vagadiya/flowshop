// To parse this JSON data, do
//
//     final sellerModel = sellerModelFromJson(jsonString);

import 'dart:convert';

SellerModel sellerModelFromJson(String str) =>
    SellerModel.fromJson(json.decode(str));

Map<String, dynamic> sellerModelToJson(SellerModel data) => data.toJson();

class SellerModel {
  SellerModel({
    this.id = 0,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.shopName,
    required this.password,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String shopName;
  final String password;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        shopName: json["shop_name"],
        password: json["password"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "shop_name": shopName,
        "password": password,
      };

  @override
  String toString() => jsonEncode({
        "id": id,
        "name": name,
        "shop_name": shopName,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      });
}
