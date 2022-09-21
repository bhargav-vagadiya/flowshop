import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Home/Dashboard.dart';
import 'package:flowshop/Login & Register/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  userIsLogged() async{
    String? username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("UserName");
    if(username==null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Login(changePassword: false,)));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Dashboard()));
    }
  }

  @override
  initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      userIsLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage),fit: BoxFit.fill,)),
        child: Stack(
          children: [
                Positioned(
                  top: 40,
                  left: -25,
                  child: Row(
                    children: [
                      Image.asset("images/icons/Line1.png"), 
                      SizedBox(width: 10,),
                      Image.asset("images/icons/RepeatGrid1.png"),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 100.0,left: 70),
                  child: Text("We will Deliver\nFragrance at your Home",style: TextStyle(fontSize: 30,color: brown),),
                ),
              Positioned(left: -110,bottom: -20,height: 390,width: 390,child: Image.asset(splashFlower))
              ],
        ),
      ),
    );
  }
}
