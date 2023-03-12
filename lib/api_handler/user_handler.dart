import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/models/user_model.dart';

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
        return null;
      }
    } on DioError catch (e) {
      log(e.toString(), name: "user login api error");
      return null;
    }
  }
}
