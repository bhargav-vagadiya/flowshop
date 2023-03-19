import 'dart:convert';
import 'dart:developer';

import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/cart_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartHandler {
  static var dio = DioConfig().dio;
  static Future<bool> addProductInCart(
      {required int productId, required int quantity}) async {
    try {
      var response = await dio.post("/carts", queryParameters: {
        "user_id": await UserHandler.getUserId(),
        "product_id": productId,
        "cart_quantity": quantity
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString(), name: "add cart api error");
      Fluttertoast.showToast(msg: "Please try after some time");
      return false;
    }
  }

  static Future<List<CartModel>?> getCart() async {
    try {
      var response =
          await dio.get("/carts/find/${await UserHandler.getUserId()}");
      if (response.statusCode == 200) {
        return cartModelFromJson(jsonEncode(response.data));
      }
    } catch (e, s) {
      log(e.toString(), name: "cart get api error");
      log(s.toString());
    }
    return null;
  }
}
