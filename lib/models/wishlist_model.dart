// To parse this JSON data, do
//
//     final wishListModel = wishListModelFromJson(jsonString);

import 'dart:convert';

import 'package:flowshop/models/product_model.dart';

List<WishListModel> wishListModelFromJson(String str) => List<WishListModel>.from(json.decode(str).map((x) => WishListModel.fromJson(x)));

String wishListModelToJson(List<WishListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishListModel {
    WishListModel({
        required this.id,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        required this.product,
    });

    final int id;
    final int userId;
    final DateTime createdAt;
    final DateTime updatedAt;
    final ProductModel product;

    factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
        id: json["id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
    };
}