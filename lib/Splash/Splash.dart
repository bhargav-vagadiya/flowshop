import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Login & Register/Login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Login()));
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
