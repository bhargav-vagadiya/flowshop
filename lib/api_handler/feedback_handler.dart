import 'dart:convert';
import 'dart:developer';

import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/feedback_model.dart';

import 'dio_config.dart';

class FeedbackHandler{
  static var dio = DioConfig().dio;

  static Future<bool> giveFeedback(
      {required double ratingValue,
        required String comment,
        required int productId}) async {
    try {
      var response = await dio.post("/feedbacks", queryParameters: {
        "product_id":productId,
        "user_id": await UserHandler.getUserId(),
        "rating_value":ratingValue,
        "comment": comment
      });
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e, s) {
      log(e.toString(), name: "feedback add api error");
      log(s.toString());
    }
    return false;
  }

  static Future<List<FeedbackModel>?> getFeedback({required int productId}) async {
    try {
      var response = await dio.get("/feedbacks/$productId");
      if (response.statusCode == 200) {
        return feedbackModelFromJson(jsonEncode(response.data));
      }
    } catch (e, s) {
      log(e.toString(), name: "feedback get api error");
      log(s.toString());
    }
    return null;
  }
}