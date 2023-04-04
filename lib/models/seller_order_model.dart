// To parse this JSON data, do
//
//     final sellerOrderModel = sellerOrderModelFromJson(jsonString);

import 'dart:convert';

import 'order_model.dart';

List<SellerOrderModel> sellerOrderModelFromJson(String str) => List<SellerOrderModel>.from(json.decode(str).map((x) => SellerOrderModel.fromJson(x)));

String sellerOrderModelToJson(List<SellerOrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SellerOrderModel {
  SellerOrderModel({
    required this.id,
    required this.totalProductPrice,
    required this.shippingCharge,
    required this.buyingTime,
    this.orderReceivedTime,
    this.orderConfirmTime,
    this.outOfDeliveryTime,
    required this.cartId,
    required this.createdAt,
    required this.updatedAt,
    required this.orderedItems,
    required this.cart,
  });

  final int id;
  final double totalProductPrice;
  final double shippingCharge;
  final DateTime buyingTime;
  final dynamic orderReceivedTime;
  final dynamic orderConfirmTime;
  final dynamic outOfDeliveryTime;
  final int cartId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderedItem> orderedItems;
  final Cart cart;

  factory SellerOrderModel.fromJson(Map<String, dynamic> json) => SellerOrderModel(
    id: json["id"],
    totalProductPrice: json["total_product_price"],
    shippingCharge: json["shipping_charge"],
    buyingTime: DateTime.parse(json["buying_time"]),
    orderReceivedTime: json["order_received_time"],
    orderConfirmTime: json["order_confirm_time"],
    outOfDeliveryTime: json["out_of_delivery_time"],
    cartId: json["cart_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    orderedItems: List<OrderedItem>.from(json["ordered_items"].map((x) => OrderedItem.fromJson(x))),
    cart: Cart.fromJson(json["cart"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_product_price": totalProductPrice,
    "shipping_charge": shippingCharge,
    "buying_time": buyingTime.toIso8601String(),
    "order_received_time": orderReceivedTime,
    "order_confirm_time": orderConfirmTime,
    "out_of_delivery_time": outOfDeliveryTime,
    "cart_id": cartId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "ordered_items": List<dynamic>.from(orderedItems.map((x) => x.toJson(isSeller: true))),
    "cart": cart.toJson(),
  };
}

class Cart {
  Cart({
    required this.user,
  });

  final User user;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String address;

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "address": address,
  };
}