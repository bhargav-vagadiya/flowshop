import 'dart:async';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrder extends StatefulWidget {
  var orderId;

  MyOrder({Key? key, required this.orderId}) : super(key: key);

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List orderDetail = [];
  List itemname = [], itemQuantity = [], itemImage = [], itemPrice=[];

  var dateTime,buyingTime,ReceiveOrderTime,ConfirmOrderTime,DeliveryTime;


  receiveOrder()async{
    if(orderDetail[0]['order_received_time']==null){
     await Future.delayed(Duration(seconds: 5),() async{
        await DbHelper.ReceiveOrder(widget.orderId, DateTime.now());
        orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
        setState(() {

          ReceiveOrderTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['order_received_time']));
        });
      });
  }
  }
  confirmOrder()async{
    if(orderDetail[0]['order_confirm_time']==null){
     await Future.delayed(Duration(seconds: 5), () async{
        await DbHelper.ConfirmOrder(widget.orderId, DateTime.now());
        orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
        setState(() {
          ConfirmOrderTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['order_confirm_time']));
        });
      });

    }
  }

  deliverOrder()async{
    if(orderDetail[0]['out_of_delivery_time']==null){
     await Future.delayed(Duration(seconds: 5), () async{
        await DbHelper.DeliverOrder(widget.orderId, DateTime.now());
        orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
        setState(() {
          DeliveryTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['out_of_delivery_time']));
        });
      });
    }
  }

  getOrderDetail() async {
    orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
    itemname = orderDetail[0]['product_name'].toString().split(",");
    itemQuantity = orderDetail[0]['quantity'].toString().split(",");
    itemImage = orderDetail[0]['image_path'].toString().split(",");
    dateTime = DateFormat.MMMMd()
        .format(DateTime.parse(orderDetail[0]['buying_time']));
    buyingTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['buying_time']));
    if (orderDetail[0]['order_received_time']!=null) {
      ReceiveOrderTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['order_received_time']));
    }
    if (orderDetail[0]['order_confirm_time']!=null) {
      ConfirmOrderTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['order_confirm_time']));
    }
    if (orderDetail[0]['out_of_delivery_time']!=null) {
      DeliveryTime = DateFormat.jm().format(DateTime.parse(orderDetail[0]['out_of_delivery_time']));
    }
    print(itemname);
    print(itemQuantity);
    print(itemImage);
    setState(() {});
    await receiveOrder();
    await confirmOrder();
    await deliverOrder();
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
      body: Column(
        children: [
          Container(
            //height: 230,
            constraints: const BoxConstraints(maxHeight: 240),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemname.length,
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
                              top: 2.0, left: 20.0, right: 20.0, bottom: 4),
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
                                              image: AssetImage(
                                                  "${itemImage[index]}")))),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${itemname[index]}",
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
                padding: const EdgeInsets.only(top: 210.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: creamColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
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
                          "${dateTime}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "images/icons/fast-delivery.png",
                              color: DeliveryTime==null? Colors.grey : Colors.black,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Order Out For",style: TextStyle(color: DeliveryTime==null? Colors.grey : Colors.black),),
                            Expanded(child: SizedBox()),
                            Text("${DeliveryTime??""}")
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/icons/order_confirmed.png",
                                color: ConfirmOrderTime==null? Colors.grey : Colors.black,
                              ),
                              SizedBox(
                                width: 21,
                              ),
                              Text("Order Confirmed",style: TextStyle(color: ConfirmOrderTime==null? Colors.grey : Colors.black),),
                              Expanded(child: SizedBox()),
                              Text("${ConfirmOrderTime??""}")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/icons/clipboard.png",
                                color: ReceiveOrderTime==null? Colors.grey:Colors.black,
                              ),
                              SizedBox(
                                width: 23,
                              ),
                              Text("Order Received",style: TextStyle(color: ReceiveOrderTime==null? Colors.grey:Colors.black),),
                              Expanded(child: SizedBox()),
                              Text("${ReceiveOrderTime??""}")
                            ],
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
                                color: buyingTime == null? Colors.grey : Colors.black,
                              ),
                              SizedBox(
                                width: 21,
                              ),
                              Text("Product Bought",style: TextStyle(color: buyingTime == null? Colors.grey : Colors.black,),),
                              Expanded(child: SizedBox()),
                              Text("${buyingTime??""}")
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
      ),
    );
  }
}
