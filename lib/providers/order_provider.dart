import 'package:flowshop/api_handler/order_handler.dart';
import 'package:flowshop/models/order_model.dart';
import 'package:flowshop/models/seller_order_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class OrderProvider extends ChangeNotifier{
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

  Future<OrderModel?> getOrderById({required int orderId}) async {
    var result = await OrderHandler.gerOrder();
    return result?.firstWhere((element) => element.id==orderId);
  }

  Future<bool> placeOrder(
      {required double totalProductPrice, required double shippingCharge}) async {
    bool result = await OrderHandler.placeOrder(
        totalProductPrice: totalProductPrice, shippingCharge: shippingCharge);
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}