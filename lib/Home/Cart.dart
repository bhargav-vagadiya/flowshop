import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/MyOrder.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/models/cart_model.dart';
import 'package:flowshop/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartModel>? item = [];
  List count = [];
  num subtotal = 0;

  getcartItem() async {
    item = await context.read<CartProvider>().getCart();
    if (item != null && item!.isNotEmpty) {
      setState(() {});
      for (int i = 0; i < item!.length; i++) {
        count.add(item![i].cartQuantity);
      }
      setState(() {});
    }
  }

  getCartItemWithQuantity() async {
    await getcartItem();
    if (item != null && item!.isNotEmpty) {
      for (int i = 0; i < item!.length; i++) {
        subtotal += (item![i].product.price * item![i].cartQuantity);
      }
      setState(() {});
    }
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
        title: Text(
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
      body: Stack(
        children: [
          Visibility(
              visible: item != null || item!.isEmpty,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/empty_cart.png",
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 20),
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
              )),
          Visibility(
            visible: item != null && item!.isNotEmpty,
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
                              product_id: item![index].product.id,
                              product_name: item![index].product.name,
                              flower_type: item![index].product.flowerType,
                              image_path: item![index].product.imageUrl,
                              qty: item![index].product.quantity,
                              price: item![index].product.price,
                              description: item![index].product.description,
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
                                                        "${item![index].product.imageUrl}")))),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${item![index].product.name}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "$curruncy${item![index].product.price * item![index].cartQuantity}",
                                              maxLines: 2,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            //Expanded(child: Text("${item[index]['description']}"))
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, right: 15.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        count[index]--;
                                                        setState(() {});
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
                                                        child: Center(
                                                            child: Text("-")),
                                                        color: Colors.white,
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("${count[index]}"),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () async {
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
                                                        child: Center(
                                                            child: Text("+")),
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
                                      // await DbHelper.removeCartProduct(
                                      //     item[index]['product_id'],
                                      //     await DbHelper.getUserId(),
                                      //     count[index]);
                                      // getcartItem();
                                    },
                                    child: Container(
                                      height: 17,
                                      width: 17,
                                      child: Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(
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
                  padding:
                      EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: creamColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(children: [
                          Text(
                            "Sub Total",
                            style: TextStyle(color: darkbrown, fontSize: 20),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "$curruncy${subtotal.toDouble()}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(children: [
                          Text(
                            "Shipping Charge",
                            style: TextStyle(color: darkbrown, fontSize: 20),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "${curruncy}10.0",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(children: [
                          Text(
                            "Bag Total",
                            style: TextStyle(color: darkbrown, fontSize: 20),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "$curruncy${subtotal + 10.00}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // getcartItem();
                            // List products = [];
                            // String result = "";
                            // for (int i = 0; i < item.length; i++) {
                            //   var productId = item[i]['product_id'];
                            //   var quantity = item[i]['cart_quantity'];
                            //   Map product = {
                            //     "product_id": productId,
                            //     "quantity": quantity
                            //   };
                            //   products.add(product);
                            // }
                            // print(products);
                            // var orderId = await DbHelper.makeOrder(
                            //     products,
                            //     await DbHelper.getUserId(),
                            //     "Cash",
                            //     DateTime.now(),
                            //     subtotal.toDouble(),
                            //     10.00);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => MyOrder(
                            //               orderId: orderId,
                            //             )));
                            // DbHelper.removeCartData(await DbHelper.getUserId());
                            // getcartItem();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 50)),
                          child: const Text(
                            "Proceed To Checkout",
                            style: TextStyle(fontSize: 25, color: creamColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
