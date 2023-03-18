// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
    ProductModel({
        required this.id,
        required this.name,
        required this.flowerType,
        required this.quantity,
        required this.price,
        this.rating,
        required this.description,
        required this.sellerId,
        required this.createdAt,
        required this.updatedAt,
    });

    final int id;
    final String name;
    final String flowerType;
    final int quantity;
    final double price;
    final dynamic rating;
    final String description;
    final int sellerId;
    final DateTime createdAt;
    final DateTime updatedAt;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        flowerType: json["flower_type"],
        quantity: json["quantity"],
        price: json["price"],
        rating: json["rating"],
        description: json["description"],
        sellerId: json["seller_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "flower_type": flowerType,
        "quantity": quantity,
        "price": price,
        "rating": rating,
        "description": description,
        "seller_id": sellerId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}