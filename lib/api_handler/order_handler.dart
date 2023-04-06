import 'dart:convert';
import 'dart:developer';

import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/order_model.dart';

import '../models/seller_model.dart';
import '../models/seller_order_model.dart';
import 'dio_config.dart';

class OrderHandler {
  static var dio = DioConfig().dio;

  static Future<bool> placeOrder(
      {required double totalProductPrice,
      required double shippingCharge}) async {
    try {
      var response = await dio.post("/ordered_items", queryParameters: {
        "user_id": await UserHandler.getUserId(),
        "total_product_price": totalProductPrice,
        "shipping_charge": shippingCharge
      });
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e, s) {
      log(e.toString(), name: "order add api error");
      log(s.toString());
    }
    return false;
  }

  static Future<List<OrderModel>?> gerOrder() async {
    try {
      var response = await dio.get("/orders/${await UserHandler.getUserId()}");
      if (response.statusCode == 200) {
        log(jsonEncode(response.data));
        var list = orderModelFromJson(jsonEncode(response.data));
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      }
    } catch (e, s) {
      log(e.toString(), name: "order get api error");
      log(s.toString());
    }
    return null;
  }

  static Future<List<SellerOrderModel>?> gerOrderSellerWise() async {
    try {
      var response = await dio.get("/orders/",
          queryParameters: {"seller_id": await UserHandler.getSellerId()});
      if (response.statusCode == 200) {
        log(jsonEncode(response.data));
        var list = sellerOrderModelFromJson(jsonEncode(response.data));
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      }
    } catch (e, s) {
      log(e.toString(), name: "order get api error");
      log(s.toString());
    }
    return null;
  }

  static Future<bool> receiveOrder({required int orderId}) async {
    try {
      var response = await dio.patch("/ordered_received_time/$orderId");
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString(), name: "receiveOrder api error");
    }
    return false;
  }

  static Future<bool> confirmOrder({required int orderId}) async {
    try {
      var response = await dio.patch("/ordered_confirm_time/$orderId");
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString(), name: "receiveOrder api error");
    }
    return false;
  }

  static Future<bool> deliverOrder({required int orderId}) async {
    try {
      var response = await dio.patch("/out_of_delivery_time/$orderId");
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString(), name: "receiveOrder api error");
    }
    return false;
  }
}
