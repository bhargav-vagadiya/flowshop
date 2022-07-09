import 'package:flowshop/Constants/Constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool PasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.fill)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100.0, left: 40),
              child: Text(
                "Login With Us",
                style: TextStyle(
                    fontSize: 35, fontWeight: FontWeight.bold, color: brown),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, bottom: 40, top: 20),
                decoration: BoxDecoration(
                    color: brownTransperent,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                     TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Username",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 20)),
                      cursorColor: Colors.white,
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      obscureText: PasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: (){
                            setState((){
                              PasswordVisible = !PasswordVisible;
                            });
                          }, icon:  Icon(Icons.remove_red_eye,color: !PasswordVisible? brown: Colors.white.withOpacity(0.50),)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Password",
                          hintStyle:
                               TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 20)),
                      cursorColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: ElevatedButton(
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(200, 60))),
              onPressed: () {},
              child: Text(
                "Login",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color(0xffe9c858)),
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: brown,fontSize: 20,fontWeight: FontWeight.w500),
                      children: [TextSpan(text: "Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),recognizer: TapGestureRecognizer()..onTap=(){

                      })])),
            )
          ],
        )
      ],
    ));
  }
}
