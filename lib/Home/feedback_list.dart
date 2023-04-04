import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/models/feedback_model.dart';
import 'package:flowshop/providers/feedback_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FeedBackList extends StatefulWidget {
  final int productId;

  const FeedBackList({Key? key, required this.productId}) : super(key: key);

  @override
  State<FeedBackList> createState() => _FeedBackListState();
}

class _FeedBackListState extends State<FeedBackList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Feedbacks"),
      ),
      body: FutureBuilder<List<FeedbackModel>?>(
          future: context
              .read<FeedbackProvider>()
              .getFeedback(productId: widget.productId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null || !snapshot.hasData) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data![index].firstName.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          RatingBar.builder(
                            itemSize: 15,
                            initialRating:
                            snapshot.data![index].ratingValue ?? 0,
                            minRating: snapshot.data![index].ratingValue ?? 0,
                            maxRating: snapshot.data![index].ratingValue ?? 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            tapOnlyMode: true,
                            itemCount: 5,
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: brown,
                                ),
                            onRatingUpdate: (rating) {},
                          ),
                          SizedBox(height: 10,),
                          Text(snapshot.data![index].comment)
                        ],
                      ),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                return const Divider(color: Colors.black,);
              },);
            }
          }),
    );
  }
}
