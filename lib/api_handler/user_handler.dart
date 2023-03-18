import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHandler {
  static var dio = DioConfig().dio;

  static Future<bool> registerUser({required UserModel userModel}) async {
    try {
      var response =
          await dio.post("/users", queryParameters: userModelToJson(userModel));
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

  static Future<bool?> userIsRegistered({required String phoneNumber}) async {
    try {
      var response =
          await dio.get("/users/find", queryParameters: {"phone": phoneNumber});
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

  static Future<UserModel?> loginUser(
      {required String phone, required String password}) async {
    try {
      var response = await dio.get('/users',
          queryParameters: {"phone": phone, "password": password});
      if (response.statusCode == 200) {
        return userModelFromJson(jsonEncode(response.data));
      } else {
        Fluttertoast.showToast(msg: "Invalid phone or password");
        return null;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user login api error");
      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "Invalid phone or password");
      } else {
        Fluttertoast.showToast(msg: "Please try after some time");
      }
      return null;
    }
  }

  static Future<Object> updateUser({required UserModel userModel}) async {
    try {
      // log("/users/${await getUserId()}");
      var response = await dio.put("/users/${await getUserId()}",
          queryParameters: userModelToJson(userModel));

      if (response.statusCode == 200) {
        return userModelFromJson(jsonEncode(response.data));
      } else {
        return false;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user update api error");
      return false;
    }
  }

  static Future<Object> updateUserPassword(
      {required String newPassword}) async {
    try {
      // log("/users/${await getUserId()}");
      var response = await dio.put("/users/${await getUserId()}",
          queryParameters: {"password": newPassword});
      if (response.statusCode == 200) {
        return userModelFromJson(jsonEncode(response.data));
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
    var model = userModelFromJson(data);
    return model.id;
  }
}
