import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flutter/material.dart';

class MyOrder extends StatefulWidget {
  var orderId;

  MyOrder({Key? key, required this.orderId}) : super(key: key);

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List orderDetail = [];
  List itemname =[],itemQuantity=[],itemImage=[];

  getOrderDetail() async {
    orderDetail = await DbHelper.getOrderDetailFromId(widget.orderId);
    itemname = orderDetail[0]['product_name'].toString().split(",");
    itemQuantity = orderDetail[0]['quantity'].toString().split(",");
    itemImage = orderDetail[0]['image_path'].toString().split(",");
    print(itemname);
    print(itemQuantity);
    print(itemImage);
    setState(() {});
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
                                      //   "\$${item[index]['price']}",
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
                  decoration: BoxDecoration(color: homeproduct,borderRadius: BorderRadius.circular(30)),
                  height: 300,
                  width: 320,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("${orderDetail[0]['buying_time']}"),
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
