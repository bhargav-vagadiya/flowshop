import 'package:flowshop/Home/Wishlist.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? username;

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
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              "Welcome,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              username.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(title: Text("My Cart"),),
          ListTile(title: Text("My Orders"),),
          ListTile(title: Text("My Wishlist"),
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Wishlist()));},),
          ListTile(
            title: Text("Change Password"),
            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(changePassword: true,)));},

          ),
          ListTile(
            title: Text("Log out"),
            onTap: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("UserName");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login(changePassword: false)));
            },
          )
        ],
      ),
    );
  }
}
