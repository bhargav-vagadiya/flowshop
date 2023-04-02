import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/OrderStatus.dart';
import 'package:flowshop/models/order_model.dart';
import 'package:flowshop/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List item = [];

  // getOrderData() async {
  //   item = await DbHelper.getOrderList();
  //
  //   setState(() {});
  // }

  @override
  initState() {
    super.initState();
    // getOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(fontFamily: "Squre"),
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "My Orders",
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
        body: FutureBuilder<List<OrderModel>?>(
          future: context.read<OrderProvider>().getOrder(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data!.isNotEmpty) {
              var item = snapshot.data!;
              return Visibility(
                visible: item.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: item.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<OrderedItem> products = item[index].orderedItems;
                        // List image_path = item[index]['image_path'].toString().split(",");
                        // List product_quantity =
                        //     item[index]['quantity'].toString().split(",");
                        // List itemPrice =
                        //     item[index]['product_price'].toString().split(",");
                        DateTime dateTime = item[index].buyingTime;
                        var time = DateFormat.d()
                            .addPattern("/")
                            .add_M()
                            .addPattern("/")
                            .add_y()
                            .addPattern("'at'")
                            .add_jm()
                            .format(dateTime);

                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyOrder(orderId: item[index].id)));
                            },
                            child: Container(
                              //    constraints: BoxConstraints(maxHeight: 130,),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: homeproduct.withOpacity(0.60),
                                  border: Border.all(color: homeProductBorderColor)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(time),
                                  Divider(
                                    thickness: 5,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          for (int i = 0; i < products.length; i++)
                                            Text("${products[i].quantity} x"),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0; i < products.length; i++)
                                            Text("${products[i].product.name}"),
                                        ],
                                      ),
                                      Expanded(child: SizedBox()),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          for (int i = 0; i < products.length; i++)
                                            Text(
                                                "$curruncy${products[i].product.price * products[i].quantity}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(thickness: 1),
                                  Row(
                                    children: [
                                      Text("Total Product Price:"),
                                      Expanded(child: SizedBox()),
                                      Text(
                                          "$curruncy${item[index].totalProductPrice}")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Shipping Charge:"),
                                      Expanded(child: SizedBox()),
                                      Text("$curruncy${item[index].shippingCharge}")
                                    ],
                                  ),
                                  Divider(thickness: 1),
                                  Row(
                                    children: [
                                      Text("Total:"),
                                      Expanded(child: SizedBox()),
                                      Text(
                                          "$curruncy${item[index].totalProductPrice + item[index].shippingCharge}")
                                    ],
                                  ),
                                  Divider(thickness: 1),
                                  GestureDetector(child: Center(child: Text("Give Feedback"),),)
                                  //Expanded(child: SizedBox()),
                                  //Text("${.day}-${DateTime.parse(item[index]['buying_time']).month}-${DateTime.parse(item[index]['buying_time']).year} at ${DateTime.parse(item[index]['buying_time']).toIso8601String()}:${DateTime.parse(item[index]['buying_time']).minute}")
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              );
            }
            else if (snapshot.connectionState != ConnectionState.waiting){
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Icon(Icons.close,size: 150,color: brown,),
                    Image.asset(
                      "images/cancel.png",
                      height: 130,
                      color: brown,
                    ),
                    Padding(
                      padding: const EdgeInsets.only( top: 20),
                      child: Text(
                        "No Orders Found",
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
              );
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        ),
      ),
    );
  }
}
