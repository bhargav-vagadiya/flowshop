import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/OrderItems.dart';
import 'package:flowshop/Home/Wishlist.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flowshop/models/user_model.dart';
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
    var user = userModelFromJson(prefs.getString("user")!);
    setState(() {
      username = "${user.firstName} ${user.lastName}";
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
      backgroundColor: creamColor,
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              "Welcome,",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              username.toString(),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: brown),
            ),
          ),
          Divider(
            color: brown,
            thickness: 5,
            height: 0,
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart_outlined,
                    color: brown,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.star_border_purple500_rounded,
                    color: brown,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderItems()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite_border,
                    color: brown,
                  ),
                  title: Text(
                    "My Wishlist",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Wishlist()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.key,
                    color: brown,
                  ),
                  title: Text(
                    "Change Password",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  changePassword: true,
                                )));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: brown,
                  ),
                  title: Text(
                    "Log out",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("user");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Login(changePassword: false)));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
