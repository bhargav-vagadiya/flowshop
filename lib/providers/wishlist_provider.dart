import 'package:flowshop/api_handler/wishlist_handler.dart';
import 'package:flowshop/models/wishlist_model.dart';
import 'package:flutter/material.dart';

class WishListProvider extends ChangeNotifier {
  Future<bool> addProductInWishList({required int productId}) async {
    bool result =
        await WishListHandler.addProductInWishList(productId: productId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeProductFromWishList({required int productId}) async {
    bool result =
        await WishListHandler.removeProductFromWishList(productId: productId);
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

  Future<List<WishListModel>?> getWishList() async {
    var result = await WishListHandler.getWishlist();
    return result;
  }
}
