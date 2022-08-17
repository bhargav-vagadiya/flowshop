import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/MyOrder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatefulWidget {
  const OrderItems({Key? key}) : super(key: key);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  List item =[];

  getOrderData() async{
    item = await DbHelper.getOrderList();

    setState(() {

    });
  }

  @override
  initState(){
    super.initState();
    getOrderData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar:  AppBar(
        title: Text("My Orders",style: TextStyle(color: darkbrown,fontWeight: FontWeight.bold),),
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
              },
              icon: Image.asset("images/icons/md-cart.webp"))
        ],
      ),
      body: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: item.length,
          itemBuilder: (BuildContext context, int index) {
            List products=item[index]['product_name'].toString().split(",");
           // List image_path = item[index]['image_path'].toString().split(",");
            List product_quantity = item[index]['quantity'].toString().split(",");
            DateTime dateTime = DateTime.parse(item[index]['buying_time']);
            var time = DateFormat.d().addPattern("/").add_M().addPattern("/").add_y().addPattern("'at'").add_jm().format(dateTime);


            return Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrder(orderId: item[index]['order_id'])));
                  // Get.to(ProductPage(
                  //   product_id: item[index]['product_id'],
                  //   product_name: item[index]['product_name'],
                  //   image_path: item[index]['image_path'],
                  //   qty: item[index]['qty'],
                  //   price: item[index]['price'],
                  //   description: item[index]['description'],
                  // ));
                },
                child: Container(
            //    constraints: BoxConstraints(maxHeight: 130,),
                  padding: EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: homeproduct.withOpacity(0.60)),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Column(children: [
                          //   for(int i=0;i<products.length;i++)
                          //     Image.asset("${image_path[i].trim()}",height: 45,),
                          //   Text("\n")
                          //     //Text("${image_path[i].trim()} x\n"),
                          //
                          // ],),
                          //SizedBox(width: 10,),
                          Column(children: [
                            for(int i=0;i<products.length;i++)
                              Text("${product_quantity[i].trim()} x\n"),

                          ],),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            for(int i=0;i<products.length;i++)
                              Text("${products[i].toString().trim()}\n"),
                          ],),
                        ],
                      ),
                      //Expanded(child: SizedBox()),
                      Divider(thickness: 1,),
                      Text(time)
                      //Text("${.day}-${DateTime.parse(item[index]['buying_time']).month}-${DateTime.parse(item[index]['buying_time']).year} at ${DateTime.parse(item[index]['buying_time']).toIso8601String()}:${DateTime.parse(item[index]['buying_time']).minute}")
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
