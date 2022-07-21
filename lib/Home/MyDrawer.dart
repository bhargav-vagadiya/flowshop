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
            title: const Text("Welcome,",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            subtitle: Text(username.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          ),
          Divider(color: Colors.black,thickness: 1,)
        ],
      ),
    );
  }
}
