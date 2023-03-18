import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowshop/api_handler/dio_config.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductHandler {
  static var dio = DioConfig().dio;

 static Future<List<ProductModel>?> getProducts() async {
    try {
      var response = await dio.get("/products");
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
