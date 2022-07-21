import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/MyDrawer.dart';
import 'package:flowshop/Home/Search.dart';
import 'package:flowshop/Login%20&%20Register/Register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scafffold = GlobalKey<ScaffoldState>();
  String? username;

  List products = [1, 2, 3, 4, 5];

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("UserName");
    });
  }

  @override
  initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafffold,
      drawer: const MyDrawer(),
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(drawerIcon),
          onPressed: () {
            _scafffold.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Register(
                              update: true,
                            )));
              },
              icon: Image.asset(profileIcon))
        ],
        title: Text("Flowshop", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(const Search(), transition: Transition.fadeIn);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.20),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 8.0, right: 5),
                  height: 40,
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Search...",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.50),
                            ),
                          )),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                top: 40,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 300,
                          width: 280,
                          decoration: BoxDecoration(
                              color: creamColor,
                              borderRadius: BorderRadius.circular(50)),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0,left: 5),
                    child: Align(alignment: Alignment.centerLeft,child:  Container(
                      height: 210,
                      width: 210,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: Image.asset("images/products/product2.webp"),
                    ),),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              height: 180,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 120,
                              width: 150,
                              decoration: BoxDecoration(color: homeproduct,border: Border.all(color: homeProductBorderColor),borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 120,
                              width: 150,
                              child: Image.asset("images/products/product3.webp"),
                            ),
                          ),
                        ),
                      ]),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
