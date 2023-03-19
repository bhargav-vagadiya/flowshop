// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:flowshop/models/product_model.dart';

List<CartModel> cartModelFromJson(String str) => List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
    CartModel({
        required this.id,
        required this.userId,
        required this.cartQuantity,
        required this.createdAt,
        required this.updatedAt,
        required this.product,
    });

    final int id;
    final int userId;
    final int cartQuantity;
    final DateTime createdAt;
    final DateTime updatedAt;
    final ProductModel product;

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        userId: json["user_id"],
        cartQuantity: json["cart_quantity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductModel.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "cart_quantity": cartQuantity,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
    };
}