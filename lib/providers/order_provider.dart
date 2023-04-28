import 'dart:convert';

import 'package:flowshop/api_handler/order_handler.dart';
import 'package:flowshop/models/order_model.dart';
import 'package:flowshop/models/seller_order_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class OrderProvider extends ChangeNotifier {
  bool loading = false;
  Future<List<OrderModel>?> getOrder() async {
    var result = await OrderHandler.gerOrder();
    return result;
  }

  Future<List<SellerOrderModel>?> getOrderSellerWise() async {
    var result = await OrderHandler.gerOrderSellerWise();
    return result;
  }
  //
  // Future<List<OrderModel>?> getOrderBySellerId() async {
  //   var result = await OrderHandler.gerOrder();
  //   // return result?.where((element) => element.);
  // }

  Future<OrderModel?> getOrderById(
      {required int orderId, bool isSeller = false}) async {
    var result = isSeller
        ? await OrderHandler.gerOrderSellerWise()
        : await OrderHandler.gerOrder();
    if (result is List<SellerOrderModel>) {
      return orderModelFromJson(
              jsonEncode(result.map((e) => e.toJson()).toList()))
          .firstWhere((element) => element.id == orderId);
    } else if (result is List<OrderModel>) {
      return result.firstWhere((element) => element.id == orderId);
    } else {
      return null;
    }
  }

  Future<bool> placeOrder(
      {required double totalProductPrice,
      required double shippingCharge}) async {
    loading = true;
    notifyListeners();
    bool result = await OrderHandler.placeOrder(
        totalProductPrice: totalProductPrice, shippingCharge: shippingCharge);
    loading = false;
    notifyListeners();
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> receivedOrder({required int orderId}) async {
    bool result = await OrderHandler.receiveOrder(orderId: orderId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> confirmOrder({required int orderId}) async {
    bool result = await OrderHandler.confirmOrder(orderId: orderId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deliverOrder({required int orderId}) async {
    bool result = await OrderHandler.deliverOrder(orderId: orderId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}
