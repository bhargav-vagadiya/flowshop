import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/Dashboard.dart';
import 'package:flowshop/Login%20&%20Register/Register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool passwordVisible = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool process = false;
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
        ListView(
         // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100.0, left: 40),
              child: Text(
                "Login With Us",
                style: TextStyle(
                    fontSize: 35, fontWeight: FontWeight.bold, color: brown),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: AutofillGroup(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 40, top: 20),
                  decoration: BoxDecoration(
                      color: brownTransperent,
                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                       TextField(
                         controller: username,
                        style: const TextStyle(color: Colors.white),
                        enableSuggestions: true,
                         textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Username (mobile number)",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 20)),
                        cursorColor: Colors.white,
                         autofillHints: const [AutofillHints.username],
                      ),
                      const SizedBox(height: 20,),
                      TextField(
                        controller: password,
                        obscureText: !passwordVisible,
                        enableSuggestions: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: (){
                              setState((){
                                passwordVisible = !passwordVisible;
                              });
                            }, icon:  Icon(Icons.remove_red_eye,color: passwordVisible? brown: Colors.white.withOpacity(0.50),)),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Password",
                            hintStyle:
                                 TextStyle(color: Colors.white.withOpacity(0.70), fontSize: 20)),
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.visiblePassword,
                        autofillHints: const [AutofillHints.password],
                        onEditingComplete: () => TextInput.finishAutofillContext(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: ElevatedButton(
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all(const Size(200, 60))),
              onPressed:  () async{
                   if(username.text.trim().isEmpty){

                   }else if(password.text.trim().isEmpty){

                   }else{
                     setState((){
                       process=true;
                     });
                     var database = await DbHelper.initdatabase();
                     bool result = await DbHelper.checkUser(database, username.text.trim(), password.text.trim());
                     setState((){
                       process=false;
                     });
                     if (kDebugMode) {
                       print(result);
                     }
                     if(result){
                       TextInput.finishAutofillContext(shouldSave: true);
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
                     }
                   }
              },
              child: process? CircularProgressIndicator() : const Text(
                "Login",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Color(0xffe9c858)),
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: brown,fontSize: 20,fontWeight: FontWeight.w500),
                      children: [TextSpan(text: "Sign in",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Register(update: false,)));
                      })])),
            )
          ],
        )
      ],
    ));
  }
}
