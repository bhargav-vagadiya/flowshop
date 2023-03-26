import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/Cart.dart';
import 'package:flowshop/Home/OrderItems.dart';
import 'package:flowshop/Home/Wishlist.dart';
import 'package:flowshop/Home/change_password.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flowshop/models/seller_model.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:flowshop/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final bool isSeller;
  const MyDrawer({Key? key, required this.isSeller}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? username;

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = widget.isSeller
        ? sellerModelFromJson(prefs.getString("seller")!)
        : buyerModelFromJson(prefs.getString("user")!);
    setState(() {
      username = user is BuyerModel
          ? "${user.firstName} ${user.lastName}"
          : user is SellerModel
              ? user.name
              : "";
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
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: brown),
            ),
          ),
          const Divider(
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
                const SizedBox(
                  height: 10,
                ),
                if (!widget.isSeller)
                  ListTile(
                    leading: const Icon(
                      Icons.shopping_cart_outlined,
                      color: brown,
                    ),
                    title: const Text(
                      "My Cart",
                      style: TextStyle(color: brown),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Cart()));
                    },
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.star_border_purple500_rounded,
                    color: brown,
                  ),
                  title: const Text(
                    "My Orders",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderItems()));
                  },
                ),
                if (!widget.isSeller)
                  ListTile(
                    leading: const Icon(
                      Icons.favorite_border,
                      color: brown,
                    ),
                    title: const Text(
                      "My Wishlist",
                      style: TextStyle(color: brown),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Wishlist()));
                    },
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.key,
                    color: brown,
                  ),
                  title: const Text(
                    "Change Password",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword(
                                  isSeller: widget.isSeller,
                                )));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: brown,
                  ),
                  title: const Text(
                    "Log out",
                    style: TextStyle(color: brown),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (widget.isSeller)
                      prefs.remove("seller");
                    else
                      prefs.remove("user");

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoleSelectionScreen()));
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
