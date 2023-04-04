// To parse this JSON data, do
//
//     final feedbackModel = feedbackModelFromJson(jsonString);

import 'dart:convert';

List<FeedbackModel> feedbackModelFromJson(String str) =>
    List<FeedbackModel>.from(
        json.decode(str).map((x) => FeedbackModel.fromJson(x)));

String feedbackModelToJson(List<FeedbackModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeedbackModel {
  FeedbackModel({
    required this.firstName,
    required this.comment,
    required this.ratingValue,
    required this.id,
    required this.productId,
    required this.userId,
     this.createdAt,
     this.updatedAt,
  });

  final String firstName;
  String comment;
  double ratingValue;
  final int id;
  final int productId;
  final int userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        firstName: json["first_name"],
        comment: json["comment"],
        ratingValue: json["rating_value"],
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "rating_value": ratingValue,
        "product_id": productId,
        "user_id": userId,
      };
}
