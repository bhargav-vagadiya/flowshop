import 'dart:convert';
import 'dart:developer';
import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/wishlist_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WishListHandler {
  static var dio = DioConfig().dio;

  static Future<bool> addProductInWishList({required int productId}) async {
    try {
      var response = await dio.post("/wishlists", queryParameters: {
        "user_id": await UserHandler.getUserId(),
        "product_id": productId
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString(), name: "add wishlist api error");
      Fluttertoast.showToast(msg: "Please try after some time");
      return false;
    }
  }

  static Future<bool> removeProductFromWishList(
      {required int productId}) async {
    WishListModel? wishListModel;
    try {
      var data = await getWishlist();
      if (data != null) {
        wishListModel =
            data.firstWhereOrNull((element) => element.product.id == productId);
      }
      var response = await dio.delete("/wishlists/${wishListModel!.id}");
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString(), name: "remove wishlist api error");
      Fluttertoast.showToast(msg: "Please try after some time");
      return false;
    }
  }

  static Future<List<WishListModel>?> getWishlist() async {
    try {
      var response =
          await dio.get("/wishlists/find/${await UserHandler.getUserId()}");
      if (response.statusCode == 200) {
        return wishListModelFromJson(jsonEncode(response.data));
      }
    } catch (e, s) {
      log(e.toString(), name: "wishlist get api error");
      log(s.toString());
    }
    return null;
  }

  static Future<bool> productInWishlist({required int productId}) async {
    try {
      var data = await getWishlist();
      if (data != null) {
        var result =
            data.firstWhereOrNull((element) => element.product.id == productId);
        if (result != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on Exception catch (e) {
      // TODO
      return false;
    }
  }
}
