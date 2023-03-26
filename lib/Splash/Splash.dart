import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/buyer_dashboard.dart';
import 'package:flowshop/Home/seller_dashboard.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flowshop/models/seller_model.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flowshop/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  userIsLogged() async {
    String? user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var roleType = prefs.getString("roleType");
    if (roleType == "buyer") {
      user = prefs.getString("user");
    } else {
      user = prefs.getString("seller");
    }

    if (user == null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => RoleSelectionScreen()));
      });
    } else {
      if (roleType == "buyer") {
        BuyerModel buyerModel = buyerModelFromJson(user);
        if (mounted) {
          bool result = await context.read<UserProvider>().loginUser(
              phone: buyerModel.phone, password: buyerModel.password);
          if (result && mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const BuyerDashboard()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => RoleSelectionScreen()));
          }
        }
      } else {
        SellerModel sellerModel = sellerModelFromJson(user);
        if (mounted) {
          bool result = await context.read<UserProvider>().loginSeller(
              phone: sellerModel.phone, password: sellerModel.password);
          if (result && mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SellerDashboard()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => RoleSelectionScreen()));
          }
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    userIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.fill,
        )),
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: -25,
              child: Row(
                children: [
                  Image.asset("images/icons/Line1.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset("images/icons/RepeatGrid1.png"),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 100.0, left: 70),
              child: Text(
                "We will Deliver\nFragrance at your Home",
                style: TextStyle(fontSize: 30, color: brown),
              ),
            ),
            Positioned(
                left: -110,
                bottom: -20,
                height: 390,
                width: 390,
                child: Image.asset(splashFlower))
          ],
        ),
      ),
    );
  }
}
