import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flowshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();

  List<ProductModel> item = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
            controller: search,
            autofocus: true,
            showCursor: true,
            cursorColor: Colors.black,
            onChanged: (value) async {
              print("executes");
              item = await context.read<ProductProvider>().searchProducts(name: value)??[];
              setState(() {});
              print(item.length);
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                focusColor: Colors.black,
                hoverColor: Colors.black,
                fillColor: Colors.black,
                hintText: "Search")),
        elevation: 1,
        actions: [
          if (search.text.isNotEmpty)
            IconButton(
                onPressed: () {
                  setState(() {
                    search.clear();
                  });
                },
                icon: Icon(Icons.close))
        ],
      ),
      backgroundColor: bgcolor,
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: item.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                Get.to(ProductPage(
                  isSeller: false,
                  product_id: item[index].id,
                  seller_id: item[index].sellerId,
                  product_name: item[index].name,
                  flower_type: item[index].flowerType,
                  image_path: item[index].imageUrl,
                  qty: item[index].quantity,
                  price: item[index].price,
                  description: item[index].description,
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: homeproduct),
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
                                image: DecorationImage(image: NetworkImage("${item[index].imageUrl}")))),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${item[index].name}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
          }),
    );
  }
}
