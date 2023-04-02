import 'dart:developer';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/MyDrawer.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/Home/add_product.dart';
import 'package:flowshop/Login%20&%20Register/seller_details.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flowshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  final GlobalKey<ScaffoldState> _scafffold = GlobalKey<ScaffoldState>();

  int sellerId = 0;

  setSellerId() async {
    sellerId = await UserHandler.getSellerId();
    setState(() {});
  }

  @override
  void initState() {
    setSellerId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scafffold,
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
                        builder: (context) => SellerDetails(
                              update: true,
                            )));
              },
              icon: Image.asset(profileIcon))
        ],
        title: const Text("Flowshop Seller",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      drawer: const MyDrawer(
        isSeller: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Text(
              "Your Products",
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: FutureBuilder<List<ProductModel>?>(
                future: Provider.of<ProductProvider>(context, listen: false)
                    .getProductsBySeller(sellerId: sellerId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: brown,
                    ));
                  }
                  if (snapshot.hasData) {
                    var item = snapshot.data;
                    return ListView.builder(
                      itemCount: item!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    isSeller: true,
                                    product_id: item[index].id,
                                    seller_id: item[index].sellerId,
                                    product_name: item[index].name,
                                    flower_type: item[index].flowerType,
                                    image_path: item[index].imageUrl,
                                    qty: item[index].quantity,
                                    price: item[index].price,
                                    description: item[index].description,
                                  ),
                                ));
                            setState(() {

                            });
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "${item[index].imageUrl}")))),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item[index].name}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${item[index].description}",
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
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No Products"),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProduct(isUpdate: false),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }
}
