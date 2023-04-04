import 'dart:convert';
import 'dart:ui';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/MyDrawer.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/Home/Search.dart';
import 'package:flowshop/Login%20&%20Register/buyer_details.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flowshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({Key? key}) : super(key: key);

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  final GlobalKey<ScaffoldState> _scafffold = GlobalKey<ScaffoldState>();
  String? username;

  List products = [];
  String? productName, productID, imagePath, description;
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
    productID = products[0]['id'];
    imagePath = products[0]['image_path'];
    qty = products[0]['qty'];
    description = products[0]['description'];
    // setState(() {});
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
        drawer: const MyDrawer(
          isSeller: false,
        ),
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                  // Fluttertoast.showToast(msg: "Feature under development");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuyerDetails(
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
                    decoration: const BoxDecoration(
                        color: homeproduct,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                child: FutureBuilder<List<ProductModel>?>(
                    future: context.read<ProductProvider>().getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var result = snapshot.data!;
                        return Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10.0, left: 100),
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
                                            offset: const Offset(5, 5),
                                          )
                                        ],
                                        color: creamColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 50.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${result[0].name}",
                                                  maxLines: 3,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: darkbrown,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Text(
                                                  "$curruncy${result[0].price}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25),
                                                  textAlign: TextAlign.left,
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0,
                                                          bottom: 20),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: InkWell(
                                                        onTap: () async {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "currently you can't add product to cart due to maintainance");
                                                          // await DbHelper
                                                          //     .addProductInCart(
                                                          //         products[0]
                                                          //             ['id'],
                                                          //         await DbHelper
                                                          //             .getUserId(),
                                                          //         1);
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder:
                                                          //             (context) =>
                                                          //                 Cart()));
                                                        },
                                                        child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              color: darkbrown,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: const Icon(
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
                                  child: Image.network("${result[0].imageUrl}",
                                      fit: BoxFit.cover),
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return context.read<ProductProvider>().loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Center(
                                child: Text("Could not get peroducts."),
                              );
                      }
                    }),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 180,
                child: FutureBuilder<List<ProductModel>?>(
                    future: context.read<ProductProvider>().getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var result = snapshot.data!;
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: result.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(ProductPage(
                                      productModel: result[index],
                                      isSeller: false,

                                    ));
                                  },
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          height: 120,
                                          width: 145,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(3, 2),
                                                )
                                              ],
                                              color: homeproduct,
                                              border: Border.all(
                                                  color:
                                                      homeProductBorderColor),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 80,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                "${result[index].name}",
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
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          height: 120,
                                          width: 150,
                                          child: Image.network(
                                              result[index].imageUrl!),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            });
                      } else {
                        return context.read<ProductProvider>().loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Center(
                                child: Text("Could not get peroducts."),
                              );
                      }
                    }),
              )
            ],
          ),
        ),
      );
}
