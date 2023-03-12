import 'dart:convert';

import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider extends ChangeNotifier {
  bool loading = false;
  Future<bool> registerUser({required UserModel userModel}) async {
    loading = true;
    notifyListeners();
    try {
      bool result = await UserHandler.registerUser(userModel: userModel);
      loading = false;
      notifyListeners();
      if (result) {
        Fluttertoast.showToast(msg: "user Successfully registered.");

        return true;
      } else {
        Fluttertoast.showToast(msg: "Please try after some time");
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      loading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: "Please try after some time");
      return false;
    }
  }

  Future<bool> loginUser(
      {required String phone, required String password}) async {
    loading = true;
    notifyListeners();
    UserModel? result =
        await UserHandler.loginUser(phone: phone, password: password);
    loading = false;
    notifyListeners();
    if (result == null) {
      Fluttertoast.showToast(msg: "Please try after some time");
      return false;
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("user", result.toString());
      return true;
    }
  }

  Future<bool> checkUserIsRegistered({required String phone}) async {
    loading = true;
    notifyListeners();
    bool? result = await UserHandler.userIsRegistered(phoneNumber: phone);
    loading = false;
    notifyListeners();
    if (result == false) {
      return false;
    } else if (result == null) {
      Fluttertoast.showToast(msg: "Please try after some time");
      return false;
    } else {
      Fluttertoast.showToast(msg: "User already exists");
      return true;
    }
  }

  void updateUser(
      {String? firstName,
      String? lastName,
      String? address,
      String? email,
      String? password}) {}
}
