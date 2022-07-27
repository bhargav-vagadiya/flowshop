import 'package:flowshop/Constants/Constant.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  String? product_name,image_path,description;
  int? product_id,qty,price;
  ProductPage({Key? key,required this.product_id,required this.product_name,required this.image_path,required this.qty,required this.price,required this.description}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
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
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 290,
              ),
              Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 125),
                    decoration: BoxDecoration(
                        color: creamColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(children: [
                      Text("${widget.product_name}")
                    ],),
                  ))
            ],
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("${widget.image_path}"),
                    fit: BoxFit.fill)),
          )
        ],
      ),
    );
  }
}
