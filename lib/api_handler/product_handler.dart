import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductHandler {
  static var dio = DioConfig().dio;

  static Future<List<ProductModel>?> getProducts({int sellerId = 0}) async {
    try {
      var response = sellerId == 0
          ? await dio.get("/products")
          : await dio.get("/products/seller/$sellerId");
      if (response.statusCode == 200) {
        return productModelFromJson(jsonEncode(response.data));
      }
    } on DioError catch (e) {
      log(e.toString(), name: "get product api error");
      Fluttertoast.showToast(msg: "Failed to load product");
    }
    return null;
  }
}
