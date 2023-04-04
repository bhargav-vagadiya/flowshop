// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:flowshop/models/product_model.dart';

List<OrderModel> orderModelFromJson(String str,{bool isSeller=false}) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
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
  });

  final int id;
  final double totalProductPrice;
  final double shippingCharge;
  final DateTime buyingTime;
  final DateTime? orderReceivedTime;
  final DateTime? orderConfirmTime;
  final DateTime? outOfDeliveryTime;
  final int cartId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderedItem> orderedItems;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    totalProductPrice: json["total_product_price"]==null? 0.0 : json["total_product_price"],
    shippingCharge: json["shipping_charge"]==null?0.0 :json["shipping_charge"],
    buyingTime: DateTime.parse(json["buying_time"]),
    orderReceivedTime: json["order_received_time"] == null ? null : DateTime.parse(json["order_received_time"]),
    orderConfirmTime: json["order_confirm_time"] == null ? null : DateTime.parse(json["order_confirm_time"]),
    outOfDeliveryTime: json["out_of_delivery_time"] == null ? null : DateTime.parse(json["out_of_delivery_time"]),
    cartId: json["cart_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    orderedItems: List<OrderedItem>.from(json["ordered_items"].map((x) => OrderedItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_product_price": totalProductPrice,
    "shipping_charge": shippingCharge,
    "buying_time": buyingTime.toIso8601String(),
    "order_received_time": orderReceivedTime?.toIso8601String(),
    "order_confirm_time": orderConfirmTime?.toIso8601String(),
    "out_of_delivery_time": outOfDeliveryTime?.toIso8601String(),
    "cart_id": cartId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "ordered_items": List<dynamic>.from(orderedItems.map((x) => x.toJson())),
  };
}

class OrderedItem {
  OrderedItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.orderId,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  final int id;
  final int productId;
  final int quantity;
  final int orderId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductModel product;

  factory OrderedItem.fromJson(Map<String, dynamic> json) => OrderedItem(
    id: json["id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    orderId: json["order_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: ProductModel.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson({bool isSeller=false}) => {
    "id": id,
    "product_id": productId,
    "quantity": quantity,
    "order_id": orderId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": isSeller==true? product.toJsonFromSellerOrderModel() : product.toJson(),
  };
}