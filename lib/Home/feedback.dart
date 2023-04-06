import 'dart:developer';

import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/feedback_model.dart';
import 'package:flowshop/providers/feedback_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import '../Constants/Constant.dart';
import '../models/product_model.dart';
import 'ProductPage.dart';

class FeedBack extends StatefulWidget {
  final List<ProductModel> products;

  const FeedBack({Key? key, required this.products}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  List<FeedbackModel> feedbacks = [];
  List<ProductModel>? item;
  int userId = 0;

  getData() async {
    userId = await UserHandler.getUserId();
    item = widget.products;
    for (var element in item!) {
      feedbacks.add(FeedbackModel(
        firstName: "",
        comment: "",
        ratingValue: 0.0,
        id: 0,
        productId: element.id,
        userId: userId,
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: item!.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  await Get.to(ProductPage(
                    isSeller: false,
                    productModel: item![index],

                  ));
                },
                child: Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: homeproduct),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${item![index]
                                                  .imageUrl}")))),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item![index].name}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${item![index].description}",
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  //Expanded(child: Text("${item[index]['description']}"))
                                ],
                              ),
                            )
                          ],
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: (rating) {
                            feedbacks[index].ratingValue = rating;
                            setState(() {});
                            print(rating);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextField(
                            onChanged: (value) {
                              feedbacks[index].comment = value;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: "Give FeedBack",
                                border: OutlineInputBorder()),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          List<FeedbackModel> feedbackResponse = [];
          feedbackResponse.addAll(feedbacks);
          feedbackResponse.removeWhere((element) =>
          element.ratingValue <= 0 ||
              (element.comment == "" || element.comment.isEmpty));

          if (feedbackResponse.isEmpty) {
            Fluttertoast.showToast(
                msg: "Please give rating to one product with comment");
          } else {
            for (var element in feedbackResponse) {
              await context.read<FeedbackProvider>().addFeedBack(
                  ratingValue: element.ratingValue,
                  comment: element.comment,
                  productId: element.productId);
            }
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.done),
        backgroundColor: brown,
      ),
    );
  }
}
