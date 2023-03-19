// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.flowerType,
    required this.quantity,
    required this.price,
    required this.sellerId,
    this.rating,
    required this.image,
  });

  final int id;
  final String name;
  final String description;
  final String flowerType;
  final int quantity;
  final double price;
  final int sellerId;
  final dynamic rating;
  final String image;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        flowerType: json["flower_type"],
        quantity: json["quantity"],
        price: json["price"],
        sellerId: json["seller_id"],
        rating: json["rating"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "flower_type": flowerType,
        "quantity": quantity,
        "price": price,
        "seller_id": sellerId,
        "rating": rating,
        "image": image,
      };
}
