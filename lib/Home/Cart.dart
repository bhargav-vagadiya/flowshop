import 'dart:developer';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/models/cart_model.dart';
import 'package:flowshop/providers/cart_provider.dart';
import 'package:flowshop/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import 'MyOrders.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartModel>? item = [];
  List count = [];
  num subtotal = 0;
  List<String> paymentMethod = ["Cash", "Online"];
  String selectedPaymentMethod = "Cash";

  getcartItem() async {
    item = await context.read<CartProvider>().getCart();
    if (item != null && item!.isNotEmpty) {
      count = item!.map((e) => e.quantity).toList();
    }
  }

  Future<List<CartModel>>? getCartItemWithQuantity() async {
    await getcartItem();
    subtotal = 0;
    if (item != null && item!.isNotEmpty) {
      for (int i = 0; i < item!.length; i++) {
        subtotal += (item![i].product.price * item![i].quantity);
      }
    }
    return item!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartItemWithQuantity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Cart",
          style: TextStyle(color: darkbrown, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("images/icons/arrow-backward.webp")),
      ),
      body: FutureBuilder<List<CartModel>?>(
          future: getCartItemWithQuantity(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var item = snapshot.data;
              return Visibility(
                visible: item != null && item.isNotEmpty,
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 375),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: item!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Get.to(ProductPage(
                                  isSeller: false,
                                  productModel: item[index].product,
                                ));
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0,
                                        left: 20.0,
                                        right: 20.0,
                                        bottom: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                        BorderRadius.circular(
                                                            20),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${item[index].product.imageUrl}")))),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${item[index].product.name}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "$curruncy${item[index].product.price * item[index].quantity}",
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                //Expanded(child: Text("${item[index]['description']}"))
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          right: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () async {
                                                            bool result = await context
                                                                .read<
                                                                    CartProvider>()
                                                                .removeCartQuantity(
                                                                    cartId: item[
                                                                            index]
                                                                        .id);
                                                            if (result) {
                                                              count[index]--;
                                                              setState(() {});
                                                            }
                                                            // await DbHelper
                                                            //     .changeCartQuantity(
                                                            //         item[index][
                                                            //             'product_id'],
                                                            //         await DbHelper
                                                            //             .getUserId(),
                                                            //         count[index],
                                                            //         true);
                                                            // subtotal -= item[index]
                                                            //     ['price'];
                                                            // getcartItem();
                                                          },
                                                          child: Container(
                                                            width: 25,
                                                            height: 25,
                                                            child: const Center(
                                                                child:
                                                                    Text("-")),
                                                            color: Colors.white,
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("${count[index]}"),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () async {
                                                            bool result = await context
                                                                .read<
                                                                    CartProvider>()
                                                                .addCartQuantity(
                                                                    cartId: item[
                                                                            index]
                                                                        .id);
                                                            if (result) {
                                                              count[index]++;
                                                              setState(() {});
                                                            }
                                                            // if (count[index] < 5) {
                                                            //   count[index]++;
                                                            //   setState(() {});
                                                            //   await DbHelper
                                                            //       .changeCartQuantity(
                                                            //           item[index][
                                                            //               'product_id'],
                                                            //           await DbHelper
                                                            //               .getUserId(),
                                                            //           count[index],
                                                            //           false);
                                                            //   subtotal +=
                                                            //       item[index]
                                                            //           ['price'];
                                                            //   getcartItem();
                                                            // }
                                                          },
                                                          child: Container(
                                                            width: 25,
                                                            height: 25,
                                                            child: const Center(
                                                                child:
                                                                    Text("+")),
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 15,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await context
                                              .read<CartProvider>()
                                              .removeCartItem(
                                                  cartId: item[index].id);
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 17,
                                          width: 17,
                                          child: const Icon(
                                            Icons.close,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ))
                                ],
                              ),
                            );
                          }),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: creamColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            const Text(
                              "Sub Total",
                              style: TextStyle(color: darkbrown, fontSize: 20),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "$curruncy${subtotal.toDouble()}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                          SizedBox(
                            height: 20.h,
                          ),
                          Stack(children: [
                            const Text(
                              "Shipping Charge",
                              style: TextStyle(color: darkbrown, fontSize: 20),
                            ),
                            const Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "${curruncy}10.0",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                          SizedBox(
                            height: 10.h,
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Stack(children: [
                            const Text(
                              "Bag Total",
                              style: TextStyle(color: darkbrown, fontSize: 20),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "$curruncy${subtotal + 10.00}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Payment Method",
                                style:
                                    TextStyle(color: darkbrown, fontSize: 20),
                              ),
                              DropdownButton<String>(
                                  value: selectedPaymentMethod,
                                  items: paymentMethod
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPaymentMethod = value!;
                                    });
                                  })
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          selectedPaymentMethod == "Online"
                              ? GooglePayButton(
                                  paymentConfigurationAsset:
                                      "payment_config/config.json",
                                  width: MediaQuery.of(context).size.width,
                                  onError: (error) {
                                    log(error.toString(), error: true);
                                  },
                                  paymentItems: [
                                    PaymentItem(
                                        amount: "${subtotal + 10.0}",
                                        label: "Flower",
                                        status: PaymentItemStatus.final_price,
                                        type: PaymentItemType.total)
                                  ],
                                  type: GooglePayButtonType.pay,
                                  margin: const EdgeInsets.only(top: 15.0),
                                  onPaymentResult: (result) async {
                                    log(result.toString());
                                    var status = await context
                                        .read<OrderProvider>()
                                        .placeOrder(
                                            totalProductPrice:
                                                subtotal.toDouble(),
                                            shippingCharge: 10.0);
                                    setState(() {});
                                    if (status) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyOrders()));
                                    }
                                  },
                                  loadingIndicator: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => MyOrder(
                                    //               orderId: orderId,
                                    //             )));
                                    var result = await context
                                        .read<OrderProvider>()
                                        .placeOrder(
                                            totalProductPrice:
                                                subtotal.toDouble(),
                                            shippingCharge: 10.0);
                                    setState(() {});
                                    if (result) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyOrders()));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          50)),
                                  child: const Text(
                                    "Proceed To Checkout",
                                    style: TextStyle(
                                        fontSize: 25, color: creamColor),
                                  ),
                                )
                        ],
                      ),
                    ))
                  ],
                ),
              );
            } else if (snapshot.connectionState != ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "images/empty_cart.png",
                      height: 200,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 20),
                      child: Text(
                        "Cart is Empty",
                        style: TextStyle(
                            color: darkbrown,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    )
                    // Text("Cart is Empty"),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
