import 'dart:async';
import 'dart:developer';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/models/order_model.dart';
import 'package:flowshop/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrder extends StatefulWidget {
  var orderId;
  bool isSeller;

  MyOrder({Key? key, required this.orderId, this.isSeller = false})
      : super(key: key);

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  OrderModel? orderDetail;
  List itemname = [], itemQuantity = [], itemImage = [], itemPrice = [];

  var buyingTime, ReceiveOrderTime, ConfirmOrderTime, DeliveryTime;
  DateTime? dateTime;

  // receiveOrder()async{
  //   if(orderDetail[0]['order_received_time']==null){
  //    await Future.delayed(Duration(seconds: 5),() async{
  //       await DbHelper.ReceiveOrder(widget.orderId, DateTime.now());
  //       orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
  //       setState(() {
  //
  //         ReceiveOrderTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['order_received_time']));
  //       });
  //     });
  // }
  // }
  // confirmOrder()async{
  //   if(orderDetail[0]['order_confirm_time']==null){
  //    await Future.delayed(Duration(seconds: 5), () async{
  //       await DbHelper.ConfirmOrder(widget.orderId, DateTime.now());
  //       orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
  //       setState(() {
  //         ConfirmOrderTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['order_confirm_time']));
  //       });
  //     });
  //
  //   }
  // }
  //
  // deliverOrder()async{
  //   if(orderDetail[0]['out_of_delivery_time']==null){
  //    await Future.delayed(Duration(seconds: 5), () async{
  //       await DbHelper.DeliverOrder(widget.orderId, DateTime.now());
  //       orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
  //       setState(() {
  //         DeliveryTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['out_of_delivery_time']));
  //       });
  //     });
  //   }
  // }

  getOrderDetail() async {
    orderDetail = await context
        .read<OrderProvider>()
        .getOrderById(orderId: widget.orderId, isSeller: widget.isSeller);
    setState(() {});
    dateTime = orderDetail!.buyingTime;
    buyingTime = DateFormat.jm().format(dateTime!);
    if (orderDetail!.orderReceivedTime != null) {
      ReceiveOrderTime =
          DateFormat.jm().format(orderDetail!.orderReceivedTime!);
    }
    if (orderDetail!.orderConfirmTime != null) {
      ConfirmOrderTime = DateFormat.jm().format(orderDetail!.orderConfirmTime!);
    }
    if (orderDetail!.outOfDeliveryTime != null) {
      DeliveryTime = DateFormat.jm().format(orderDetail!.outOfDeliveryTime!);
    }
    log(orderDetail!.orderedItems[0].product.imageUrl ?? "null", name: "Hello");
    // print(itemname);
    // print(itemQuantity);
    // print(itemImage);
    // setState(() {});
    // await receiveOrder();
    // await confirmOrder();
    // await deliverOrder();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Order Status",
          style: TextStyle(color: darkbrown, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("images/icons/arrow-backward.webp")),
      ),
      body: orderDetail != null
          ? Column(
              children: [
                Container(
                  //height: 230,
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: orderDetail!.orderedItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // Get.to(ProductPage(
                            //   product_id: item[index]['product_id'],
                            //   product_name: item[index]['product_name'],
                            //   image_path: item[index]['image_path'],
                            //   qty: item[index]['qty'],
                            //   price: item[index]['price'],
                            //   description: item[index]['description'],
                            // ));
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
                                                        "http://20.219.59.136:3000/${orderDetail!.orderedItems[index].product.imageUrl}")))),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${orderDetail!.orderedItems[index].product.name}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // Text(
                                            //   "$curruncy${item[index]['price']}",
                                            //   maxLines: 2,
                                            //   softWrap: true,
                                            //   overflow: TextOverflow.ellipsis,
                                            // ),
                                            //Expanded(child: Text("${item[index]['description']}"))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                //SizedBox(height: 50,),
                Expanded(
                    child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: creamColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: homeproduct,
                            borderRadius: BorderRadius.circular(30)),
                        height: 300,
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${dateTime!.day}/${dateTime!.month}/${dateTime!.year}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () async{
                                 if (ReceiveOrderTime != null && ConfirmOrderTime !=  null) {
                                   await context
                                        .read<OrderProvider>()
                                        .deliverOrder(orderId: widget.orderId);
                                 }else if(ReceiveOrderTime != null){
                                   await context
                                       .read<OrderProvider>()
                                       .confirmOrder(orderId: widget.orderId);
                                   await context
                                       .read<OrderProvider>()
                                       .deliverOrder(orderId: widget.orderId);
                                 }else{
                                   await context
                                       .read<OrderProvider>()
                                       .receivedOrder(orderId: widget.orderId);
                                   await context
                                       .read<OrderProvider>()
                                       .confirmOrder(orderId: widget.orderId);
                                   await context
                                       .read<OrderProvider>()
                                       .deliverOrder(orderId: widget.orderId);
                                 }
                                 getOrderDetail();
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/icons/fast-delivery.png",
                                      color: DeliveryTime == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      widget.isSeller
                                          ? "Deliver Order"
                                          : "Order Out For",
                                      style: TextStyle(
                                          color: DeliveryTime == null
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text("${DeliveryTime ?? ""}")
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async{
                                  if(ReceiveOrderTime != null) {
                                    await context
                                      .read<OrderProvider>()
                                      .confirmOrder(orderId: widget.orderId);
                                  }else{
                                    await context
                                        .read<OrderProvider>()
                                        .receivedOrder(orderId: widget.orderId);

                                    await context
                                        .read<OrderProvider>()
                                        .confirmOrder(orderId: widget.orderId);
                                  }
                                  getOrderDetail();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "images/icons/order_confirmed.png",
                                        color: ConfirmOrderTime == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: 21,
                                      ),
                                      Text(
                                        widget.isSeller
                                            ? "Confirm Order"
                                            : "Order Confirmed",
                                        style: TextStyle(
                                            color: ConfirmOrderTime == null
                                                ? Colors.grey
                                                : Colors.black),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text("${ConfirmOrderTime ?? ""}")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async{
                                  await context
                                      .read<OrderProvider>()
                                      .receivedOrder(orderId: widget.orderId);
                                  getOrderDetail();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "images/icons/clipboard.png",
                                        color: ReceiveOrderTime == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                      SizedBox(
                                        width: 23,
                                      ),
                                      Text(
                                        widget.isSeller
                                            ? "Receive Order"
                                            : "Order Received",
                                        style: TextStyle(
                                            color: ReceiveOrderTime == null
                                                ? Colors.grey
                                                : Colors.black),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text("${ReceiveOrderTime ?? ""}")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/icons/add-to-cart.png",
                                      color: buyingTime == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                    SizedBox(
                                      width: 21,
                                    ),
                                    Text(
                                      "Product Bought",
                                      style: TextStyle(
                                        color: buyingTime == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text("${buyingTime ?? ""}")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            )
          : Container(),
    );
  }
}
