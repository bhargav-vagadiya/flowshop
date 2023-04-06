import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/Home/Search.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flowshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({
    super.key,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "All Products",
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
              onPressed: () async {
                //Navigator.pop(context);
                await Get.to(const Search(), transition: Transition.fadeIn);
                setState(() {});
              },
              icon: const Icon(
                Icons.search,
                color: brown,
              ))
        ],
      ),
      body: FutureBuilder<List<ProductModel>?>(
          future: context.read<ProductProvider>().getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<ProductModel> item = snapshot.data!;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: item.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        await Get.to(ProductPage(
                          isSeller: false,
                          productModel: item[index],
                        ));
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 10.0, right: 10.0),
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
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${item[index].imageUrl}")))),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item[index].name}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${item[index].description}",
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    //Expanded(child: Text("${item[index]['description']}"))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.connectionState != ConnectionState.waiting) {
              return Center(
                child: Text("No Products"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
