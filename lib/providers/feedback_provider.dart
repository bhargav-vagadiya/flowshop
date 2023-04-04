import 'package:flowshop/api_handler/feedback_handler.dart';
import 'package:flutter/material.dart';

import '../models/feedback_model.dart';

class FeedbackProvider extends ChangeNotifier{
  Future<bool> addFeedBack(
      {required double ratingValue,required String comment, required int productId}) async {
    bool result = await FeedbackHandler.giveFeedback(
        ratingValue: ratingValue,comment: comment, productId: productId);
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<FeedbackModel>?> getFeedback({required int productId}) async {
    var result = await FeedbackHandler.getFeedback(productId: productId);
    return result;
  }
}