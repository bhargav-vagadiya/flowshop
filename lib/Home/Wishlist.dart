import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/models/wishlist_model.dart';
import 'package:flowshop/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<WishListModel>? item = [];

  getData() async {
    // var userId = aw;
    item = await context.read<WishListProvider>().getWishList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Wishlist",
          style: TextStyle(color: darkbrown, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("images/icons/arrow-backward.webp")),
        actions: [
          IconButton(
              onPressed: () {
                //Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()));
              },
              icon: Image.asset("images/icons/md-cart.webp"))
        ],
      ),
      body: Stack(
        children: [
          Visibility(
              visible: item == null || item!.isEmpty,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(Icons.close,size: 150,color: brown,),
                    Image.asset(
                      "images/cancel.png",
                      height: 130,
                      color: brown,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Wishlist is Empty",
                        style: TextStyle(
                            fontFamily: "Squre",
                            color: darkbrown,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    )
                    // Text("Cart is Empty"),
                  ],
                ),
              )),
          Visibility(
            visible: item != null || item!.isNotEmpty,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: item!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      await Get.to(ProductPage(
                        isSeller: false,
                        productModel: item![index].product
                      ));
                      if (mounted) {
                        getData();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: homeproduct),
                        child: Row(
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
                                              "${item![index].product.imageUrl}")))),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item![index].product.name}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${item![index].product.description}",
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
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
