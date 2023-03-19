import 'package:flowshop/api_handler/wishlist_handler.dart';
import 'package:flutter/material.dart';

class WishListProvider extends ChangeNotifier {
  Future<bool> addProductInWidhList({required int productId}) async {
    bool result =
        await WishListHandler.addProductInWishList(productId: productId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> productInWishlist({required int productId}) async {
    bool result = await WishListHandler.productInWishlist(productId: productId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}
