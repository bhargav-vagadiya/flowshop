import 'dart:convert';
import 'dart:ui';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/MyDrawer.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/Home/Search.dart';
import 'package:flowshop/Login%20&%20Register/Register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scafffold = GlobalKey<ScaffoldState>();
  String? username;

  List products = [];
  String? productName,productID,imagePath,description;
  double? productPrice;
  int? qty;

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("UserName");
    });
  }

  fillProducts() async {
    var db = await DbHelper.initdatabase();
    var ProductList = await DbHelper.getProductDetails(db);
    products = ProductList;
    productName = products[0]['product_name'];
    productPrice = products[0]['price'];
    productID=products[0]['id'];
    imagePath=products[0]['image_path'];
    qty=products[0]['qty'];
    description=products[0]['description'];
    setState(() {});
    return ProductList;
  }

  @override
  initState() {
    super.initState();
    getUserName();
    fillProducts();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scafffold,
      drawer: const MyDrawer(),
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(drawerIcon),
          onPressed: () {
            _scafffold.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Register(
                              update: true,
                            )));
              },
              icon: Image.asset(profileIcon))
        ],
        title: const Text("Flowshop", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(const Search(), transition: Transition.fadeIn);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: homeproduct,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 8.0, right: 5),
                  height: 40,
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Search...",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.50),
                            ),
                          )),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                top: 40,
              ),
              child: FutureBuilder(
                future: fillProducts(),
                builder: (context,snapshot){
                  var result = snapshot.data.toString();
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 100),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      blurRadius: 8,
                                      offset: Offset(5, 5),
                                    )
                                  ],
                                  color: creamColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 120,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${products[0]['product_name']}",
                                            maxLines: 3,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: darkbrown,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "$curruncy${productPrice}",
                                            style: const TextStyle(
                                                color: Colors.black, fontSize: 25),
                                            textAlign: TextAlign.left,
                                          ),
                                          Expanded(child: SizedBox()),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0, bottom: 20),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                  onTap: () async{
                                                    await DbHelper.addProductInCart(products[0]['id'], await DbHelper.getUserId(),1);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Cart()));
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: darkbrown,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: creamColor,
                                                      size: 50,
                                                    ),
                                                  )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      Positioned(
                        left: 5,
                        top: 50,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 210,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: Image.asset("$imagePath",
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                    ],
                  );
                }
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ProductPage(
                            product_id: products[index]['product_id'],
                            product_name: products[index]['product_name'],
                            image_path: products[index]['image_path'],
                            qty: products[index]['qty'],
                            price: products[index]['price'],
                            description: products[index]['description'],
                          ));
                        },
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                height: 120,
                                width: 145,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        blurRadius: 6,
                                        offset: Offset(3, 2),
                                      )
                                    ],
                                    color: homeproduct,
                                    border: Border.all(
                                        color: homeProductBorderColor),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "${products[index]['product_name']}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 120,
                                width: 150,
                                child: Image.asset(
                                    "${products[index]['image_path']}"),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
}
