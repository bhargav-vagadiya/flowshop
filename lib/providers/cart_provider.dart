import 'package:flowshop/api_handler/cart_handler.dart';
import 'package:flowshop/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class CartProvider extends ChangeNotifier {
  Future<bool> addProductInCart(
      {required int productId,
      required int sellerId,
      required int quantity}) async {
    var cartItems = await getCart();
    if (cartItems != null && cartItems.isNotEmpty) {
      var cartModel = cartItems
          .firstWhereOrNull((element) => element.product.sellerId == sellerId);
      if (cartModel != null) {
        bool result = await CartHandler.addProductInCart(
            productId: productId, quantity: quantity);
        if (result) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      bool result = await CartHandler.addProductInCart(
          productId: productId, quantity: quantity);
      if (result) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<List<CartModel>?> getCart() async {
    var result = await CartHandler.getCart();
    return result;
  }

  Future<bool> addCartQuantity({required int cartId}) async {
    var result = await CartHandler.addCartQuantity(cartId: cartId);
    return result;
  }

  Future<bool> removeCartQuantity({required int cartId}) async {
    var result = await CartHandler.removeCartQuantity(cartId: cartId);
    return result;
  }

  Future<bool> removeCartItem({required int cartId}) async {
    var result = await CartHandler.removeCartItem(cartId: cartId);
    return result;
  }
}
