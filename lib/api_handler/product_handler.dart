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
        // log(jsonEncode(response.data));
        log(productModelFromJson(jsonEncode(response.data)).toString());
        return productModelFromJson(jsonEncode(response.data));
      }
    } on DioError catch (e) {
      log(e.toString(), name: "get product api error");
      Fluttertoast.showToast(msg: "Failed to load product");
    }
    return null;
  }

  static Future<List<ProductModel>?> searchProducts({required String name}) async {
    try {
      var response =
          await dio.get("/products/search",queryParameters: {
            "name": name
          });
      if (response.statusCode == 200) {
        return productModelFromJson(jsonEncode(response.data));
      }
    } on DioError catch (e) {
      log(e.toString(), name: "search product api error");
      Fluttertoast.showToast(msg: "Failed to load product");
    }
    return null;
  }

  static Future<bool> addProduct(ProductModel productModel) async {
    FormData formData = FormData.fromMap(productModel.toJson());

    var response = await dio.post("/products/", data: formData);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateProduct(ProductModel productModel) async {
    FormData formData = productModel.imageUrl!.contains("http://")
        ? FormData.fromMap(productModel.toJsonWithoutImage())
        : FormData.fromMap(productModel.toJson());

    var response =
        await dio.put("/products/${productModel.id}", data: formData);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateProductToOutOfStock(int productID) async {
    var response =
    await dio.put("/products/${productID}",queryParameters: {
      "quantity":0
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteProduct(int productID) async {
    Response<dynamic>? response;
    try {
      response = await dio.delete("/products/$productID");
      if (response.statusCode == 200) {
        return true;
      } else {

        return false;
      }
    } catch (e) {

        updateProductToOutOfStock(productID);

      log(e.toString());
     return false;
    }
  }
}
