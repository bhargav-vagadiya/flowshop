import 'dart:convert';
import 'dart:developer';

import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/seller_model.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider extends ChangeNotifier {
  bool loading = false;
  Future<bool> registerUser(
      {BuyerModel? buyerModel, SellerModel? sellerModel}) async {
    loading = true;
    notifyListeners();
    try {
      bool result = buyerModel != null
          ? await UserHandler.registerUser(buyerModel: buyerModel)
          : await UserHandler.registerUser(sellerModel: sellerModel!);
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

    BuyerModel? result =
        await UserHandler.loginUser(phone: phone, password: password);
    loading = false;
    notifyListeners();
    if (result == null) {
      return false;
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("user", result.toString());
      return true;
    }
  }

  Future<bool> loginSeller(
      {required String phone, required String password}) async {
    loading = true;
    notifyListeners();

    SellerModel? result =
        await UserHandler.loginSeller(phone: phone, password: password);
    loading = false;
    notifyListeners();
    if (result == null) {
      return false;
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("seller", result.toString());
      return true;
    }
  }

  Future<bool> checkUserIsRegistered(
      {required String phone, required bool isSeller}) async {
    loading = true;
    notifyListeners();
    bool? result = await UserHandler.userIsRegistered(
        phoneNumber: phone, isSeller: isSeller);
    loading = false;
    notifyListeners();
    if (result == false) {
      return false;
    } else if (result == null) {
      Fluttertoast.showToast(msg: "Please try after some time");
      return true;
    } else {
      Fluttertoast.showToast(msg: "User already exists");
      return true;
    }
  }

  Future<bool> updateUser(
      {BuyerModel? buyerModel, SellerModel? sellerModel}) async {
    loading = true;
    notifyListeners();

    var result = sellerModel == null
        ? await UserHandler.updateUser(buyerModel: buyerModel)
        : await UserHandler.updateUser(sellerModel: sellerModel);
    loading = false;
    notifyListeners();
    if (result is BuyerModel) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("user", result.toString());
      return true;
    } else if (result is SellerModel) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("seller", result.toString());
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUserPassword(
      {required bool isSeller,
      required String oldPassword,
      required String newPassword}) async {
    loading = true;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String data = isSeller
        ? preferences.getString("seller")!
        : preferences.getString("user")!;
    String password = isSeller
        ? sellerModelFromJson(data).password
        : buyerModelFromJson(data).password;
    if (password == oldPassword) {
      var result = await UserHandler.updateUserPassword(
          isSeller: isSeller, newPassword: newPassword);
      loading = false;
      notifyListeners();
      if (result is BuyerModel) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("user", result.toString());
        return true;
      } else if (result is SellerModel) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString("seller", result.toString());
        return true;
      } else {
        return false;
      }
    } else {
      loading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: "Old password is incorrect");
      return false;
    }
  }
}
