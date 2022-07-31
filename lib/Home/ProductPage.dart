import 'package:flowshop/Constants/Constant.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  String? product_name, image_path, description;
  int? product_id, qty, price;

  ProductPage(
      {Key? key,
      required this.product_id,
      required this.product_name,
      required this.image_path,
      required this.qty,
      required this.price,
      required this.description})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isfavorite=false;
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
         clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 110),
                decoration: const BoxDecoration(
                    color: creamColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50, left: 20),
                      child: Text(
                        "${widget.product_name}",
                        style: const TextStyle(
                            color: darkbrown,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50, left: 20),
                      child: SingleChildScrollView(
                          child: Text(
                        "${widget.description}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.4),
                        fontWeight: FontWeight.bold),
                      )),
                    ),
                    const Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, bottom: 10),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Price"),
                              Text("\$${widget.price}")
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Add to Cart")))
                      ],
                    ),
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
          GestureDetector(

            onTap: (){
              print("object");
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.88,
                  top: MediaQuery.of(context).size.height * 0.42),
              child: Column(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isfavorite? darkbrown:null),
                      child: isfavorite? const Icon(
                        Icons.favorite,
                        size: 30,
                        color: creamColor,
                      ):
                      const Icon(
                        Icons.favorite_border,
                        size: 30,
                        color: darkbrown,
                      )),
                  // const Text("data"),
                  // const Text("data")
                ],
              ),
            ),
          ),
          Container(
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        //NetworkImage("https://img.teleflora.com/images/o_0/l_flowers:TEV58-7C,pg_6/w_368,h_460,cs_no_cmyk,c_pad/f_jpg,q_auto:eco,e_sharpen:200/flowers/TEV58-7C/Teleflora'sMidModBrightsBouquetPM?image=9"),
                        AssetImage("${widget.image_path}"),
                    fit: BoxFit.contain)),
          )
        ],
      ),
    );
  }
}
