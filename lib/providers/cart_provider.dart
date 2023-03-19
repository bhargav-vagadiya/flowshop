import 'package:flowshop/api_handler/cart_handler.dart';
import 'package:flowshop/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Future<bool> addProductInCart(
      {required int productId, required int quantity}) async {
    bool result = await CartHandler.addProductInCart(
        productId: productId, quantity: quantity);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<CartModel>?> getCart() async {
    var result = await CartHandler.getCart();
    return result;
  }
}
