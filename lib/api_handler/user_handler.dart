import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/models/seller_model.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHandler {
  static var dio = DioConfig().dio;

  static Future<bool> registerUser(
      {BuyerModel? buyerModel, SellerModel? sellerModel}) async {
    try {
      var response = buyerModel != null
          ? await dio.post("/users",
              queryParameters: buyerModelToJson(buyerModel))
          : await dio.post("/sellers",
              queryParameters: sellerModelToJson(sellerModel!));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user register api error");
      return false;
    }
  }

  static Future<bool?> userIsRegistered(
      {required String phoneNumber, required bool isSeller}) async {
    try {
      var response = await dio.get(isSeller ? "/sellers/find" : "/users/find",
          queryParameters: {"phone": phoneNumber});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user check api error");

      if (e.type == DioErrorType.connectionTimeout) {
        return null;
      }
      return false;
    }
  }

  static Future<BuyerModel?> loginUser(
      {required String phone, required String password}) async {
    try {
      var response = await dio.get('/users',
          queryParameters: {"phone": phone, "password": password});
      if (response.statusCode == 200) {
        return buyerModelFromJson(jsonEncode(response.data));
      } else {
        Fluttertoast.showToast(msg: "Invalid phone or password");
        return null;
      }
    } on DioError catch (e) {
      log(e.message.toString(), name: "user login api error");
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "Invalid phone or password");
      } else {
        Fluttertoast.showToast(msg: "Please try after some time");
      }
      return null;
    }
  }

  static Future<SellerModel?> loginSeller(
      {required String phone, required String password}) async {
    try {
      var response = await dio.get('/sellers',
          queryParameters: {"phone": phone, "password": password});
      if (response.statusCode == 200) {
        return sellerModelFromJson(jsonEncode(response.data));
      } else {
        Fluttertoast.showToast(msg: "Invalid phone or password");
        return null;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "seller login api error");
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "Invalid phone or password");
      } else {
        Fluttertoast.showToast(msg: "Please try after some time");
      }
      return null;
    }
  }

  static Future<Object> updateUser(
      {BuyerModel? buyerModel, SellerModel? sellerModel}) async {
    try {
      // log("/users/${await getUserId()}");
      var response = buyerModel != null
          ? await dio.put("/users/${await getUserId()}",
              queryParameters: buyerModelToJson(buyerModel))
          : await dio.put("/sellers/${await getSellerId()}",
              queryParameters: sellerModelToJson(sellerModel!));

      if (response.statusCode == 200) {
        return buyerModel != null
            ? buyerModelFromJson(jsonEncode(response.data))
            : sellerModelFromJson(jsonEncode(response.data));
      } else {
        return false;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user update api error");
      return false;
    }
  }

  static Future<Object> updateUserPassword(
      {required bool isSeller, required String newPassword}) async {
    try {
      // log("/users/${await getUserId()}");
      var response = isSeller
          ? await dio.put("/sellers/${await getSellerId()}",
              queryParameters: {"password": newPassword})
          : await dio.put("/users/${await getUserId()}",
              queryParameters: {"password": newPassword});
      if (response.statusCode == 200) {
        return isSeller
            ? sellerModelFromJson(jsonEncode(response.data))
            : buyerModelFromJson(jsonEncode(response.data));
      } else {
        return false;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user update password api error");
      return false;
    }
  }

  static Future<int> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String data = preferences.getString("user")!;
    var model = buyerModelFromJson(data);
    return model.id;
  }

  static Future<int> getSellerId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String data = preferences.getString("seller")!;
    var model = sellerModelFromJson(data);
    return model.id;
  }
}
