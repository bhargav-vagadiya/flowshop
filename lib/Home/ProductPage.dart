import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/add_product.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flowshop/providers/cart_provider.dart';
import 'package:flowshop/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductPage extends StatefulWidget {
  String? product_name, image_path, flower_type, description;
  int? product_id,seller_id, qty;
  double? price;
  bool isSeller;

  ProductPage(
      {Key? key,
      required this.isSeller,
      required this.product_id,
      required this.seller_id,
      required this.product_name,
      required this.flower_type,
      required this.image_path,
      required this.qty,
      required this.price,
      required this.description})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isfavorite = false;
  int count = 1;

  favoriteOrNot() async {
    // isfavorite = await DbHelper.productInWishlist(
    //     widget.product_id, await DbHelper.getUserId());
    isfavorite = await context
        .read<WishListProvider>()
        .productInWishlist(productId: widget.product_id!);
    print(isfavorite);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favoriteOrNot();
  }

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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()));
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
                      padding: const EdgeInsets.only(right: 50, left: 30),
                      child: Text(
                        "${widget.product_name}",
                        style: const TextStyle(
                            color: darkbrown,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50, left: 30),
                      child: SingleChildScrollView(
                          child: Text(
                        "${widget.description}",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.4),
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    const Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20, left: 30, bottom: 10),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Price",
                                    style: TextStyle(
                                        color: brown,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "$curruncy${widget.price}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(200, 60)),
                                    onPressed: () async {
                                      if (!widget.isSeller) {
                                        print(count);
                                        var item = await context
                                            .read<CartProvider>()
                                            .getCart();

                                        var cartItem = item!.firstWhereOrNull(
                                            (element) =>
                                                element.product.id ==
                                                widget.product_id);
                                        if (cartItem != null) {
                                          for (int i = 0; i < count; i++) {
                                            await context
                                                .read<CartProvider>()
                                                .addCartQuantity(
                                                    cartId: cartItem.id);
                                          }
                                        } else {
                                          await context
                                              .read<CartProvider>()
                                              .addProductInCart(
                                                  productId: widget.product_id!,
                                                  quantity: count,sellerId: widget.seller_id!);
                                        }

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Cart()));
                                      } else {
                                        var sellerId =
                                            await UserHandler.getSellerId();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProduct(
                                                      isUpdate: true,
                                                      productModel: ProductModel(
                                                          id: widget
                                                              .product_id!,
                                                          name: widget
                                                              .product_name!,
                                                          description: widget
                                                              .description!,
                                                          flowerType: widget
                                                              .flower_type!,
                                                          quantity: widget.qty!,
                                                          price: widget.price!,
                                                          sellerId: sellerId,
                                                          imageUrl: widget
                                                              .image_path),
                                                    )));
                                      }
                                    },
                                    child: Text(
                                      widget.isSeller
                                          ? "Update Product"
                                          : "Add to Cart",
                                      style: TextStyle(
                                          fontSize: 25, color: creamColor),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
          Container(
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        //NetworkImage("https://img.teleflora.com/images/o_0/l_flowers:TEV58-7C,pg_6/w_368,h_460,cs_no_cmyk,c_pad/f_jpg,q_auto:eco,e_sharpen:200/flowers/TEV58-7C/Teleflora'sMidModBrightsBouquetPM?image=9"),
                        NetworkImage(
                      "${widget.image_path}",
                    ),
                    fit: BoxFit.contain)),
          ),
          if (!widget.isSeller)
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.88,
                  top: 270,
                  right: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (await context
                          .read<WishListProvider>()
                          .productInWishlist(productId: widget.product_id!)) {
                        var result = await context
                            .read<WishListProvider>()
                            .removeProductFromWishList(
                                productId: widget.product_id!);

                        if (result) {
                          isfavorite = false;
                        }
                      } else {
                        // await DbHelper.addWishlist(widget.product_id, userid);
                        var result = await context
                            .read<WishListProvider>()
                            .addProductInWishList(
                                productId: widget.product_id!);
                        if (result) {
                          isfavorite = true;
                        }
                      }
                      setState(() {});
                    },
                    child: Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isfavorite ? darkbrown : null),
                        child: isfavorite
                            ? const Icon(
                                Icons.favorite,
                                size: 25,
                                color: creamColor,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: darkbrown,
                              )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    width: 25,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(5)),
                        border: Border.all(color: const Color(0xffb7a361))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (count < 5) {
                                count++;
                              }
                            });
                          },
                          child: Container(
                            color: const Color(0xffb7a361),
                            width: 25,
                            child: const Center(
                                child: Icon(
                              Icons.add_sharp,
                              color: darkbrown,
                              size: 25,
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                            child: Text(
                          "$count",
                          style: TextStyle(
                              color: darkbrown, fontWeight: FontWeight.bold),
                        )),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (count > 1) {
                                  count--;
                                }
                              });
                            },
                            child: Container(
                              color: const Color(0xffb7a361),
                              width: 25,
                              child: const Center(
                                  child: Icon(
                                Icons.remove,
                                color: darkbrown,
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  // const Text("data"),
                  // const Text("data")
                ],
              ),
            ),
        ],
      ),
    );
  }
}
