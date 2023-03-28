import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/ProductPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();

  List item = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: search,
            autofocus: true,
            showCursor: true,
            cursorColor: Colors.black,
            onChanged: (value) async {
              print("executes");
              item = await DbHelper.searchProduct(value);
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
                  product_id: item[index]['product_id'],
                  product_name: item[index]['product_name'],
                  flower_type: item[index]['flower_type'],
                  image_path: item[index]['image_path'],
                  qty: item[index]['qty'],
                  price: item[index]['price'],
                  description: item[index]['description'],
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
                                image: DecorationImage(image: AssetImage("${item[index]['image_path']}")))),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${item[index]['product_name']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            Text(
                              "${item[index]['description']}",
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
