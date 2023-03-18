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
}
