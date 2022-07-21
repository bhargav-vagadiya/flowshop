import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/MyDrawer.dart';
import 'package:flowshop/Login%20&%20Register/Register.dart';
import 'package:flutter/material.dart';
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
                        builder: (context) => Register(update: true)));
              },
              icon: Image.asset(profileIcon))
        ],
        title: Text("Flowshop", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(decoration: InputDecoration(border: OutlineInputBorder(),),),
          ),
        ],
      ),
    );
  }
}
