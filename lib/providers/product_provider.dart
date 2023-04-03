import 'dart:developer';

import 'package:flowshop/api_handler/product_handler.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  bool _loading = false;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading => _loading;

  Future<List<ProductModel>?> getProducts() async {
    loading = true;
    var products = await ProductHandler.getProducts();
    loading = false;
    return products;
  }

  Future<List<ProductModel>?> getProductsBySeller(
      {required int sellerId}) async {
    var products = await ProductHandler.getProducts(sellerId: sellerId);
    log(products.toString(), name: "seller wise product");
    return products;
  }

  Future<List<ProductModel>?> searchProducts(
      {required String name}) async {
    var products = await ProductHandler.searchProducts(name: name);
    log(products.toString(), name: "seller wise product");
    return products;
  }

  Future<bool> addProduct(ProductModel productModel) async {
    bool result = await ProductHandler.addProduct(productModel);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel productModel) async {
    bool result = await ProductHandler.updateProduct(productModel);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(int productID) async {
    bool result = await ProductHandler.deleteProduct(productID);
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}
