import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Home/buyer_dashboard.dart';
import 'package:flowshop/Home/seller_dashboard.dart';
import 'package:flowshop/Login%20&%20Register/register.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  final bool isSeller;
  const Login({Key? key, required this.isSeller}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool process = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(brown))),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: creamColor,
          body: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100.0.h, left: 40.w),
                    child: Text(
                      "Login With Us",
                      style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                          color: brown),
                    ),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                    child: AutofillGroup(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0.w, right: 20.w, bottom: 40.h, top: 20.h),
                        decoration: BoxDecoration(
                            color: brownTransperent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            TextField(
                              controller: username,
                              inputFormatters: [
                                FilteringTextInputFormatter(RegExp("[+ ]"),
                                    allow: false)
                              ],
                              style: const TextStyle(color: Colors.white),
                              enableSuggestions: true,
                              maxLength: 10,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  counterText: "",
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: "Phone number",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 17.sp)),
                              cursorColor: Colors.white,
                              autofillHints: const [AutofillHints.username],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: password,
                              obscureText: !passwordVisible,
                              enableSuggestions: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: passwordVisible
                                            ? brown
                                            : Colors.white.withOpacity(0.50),
                                      )),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 17.sp)),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.visiblePassword,
                              autofillHints: const [AutofillHints.password],
                              onEditingComplete: () =>
                                  TextInput.finishAutofillContext(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  Center(
                      child: ElevatedButton(
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(170.w, 50.h))),
                    onPressed: () async {
                      if (username.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "please enter phone number");
                      } else if (password.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "please enter password");
                      } else {
                        // var database = await DbHelper.initdatabase();
                        var provider = context.read<UserProvider>();

                        bool result = widget.isSeller
                            ? await provider.loginSeller(
                                phone: username.text.trim(),
                                password: password.text.trim())
                            : await provider.loginUser(
                                phone: username.text.trim(),
                                password: password.text.trim());

                        if (kDebugMode) {
                          print(result);
                        }
                        if (result && mounted) {
                          if (widget.isSeller) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SellerDashboard()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BuyerDashboard()));
                          }
                        }
                      }
                    },
                    child: context.watch<UserProvider>().loading
                        ? const CircularProgressIndicator()
                        : Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffe9c858)),
                          ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RichText(
                        text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                color: brown,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                            children: [
                          TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register(
                                                isSeller: widget.isSeller,
                                              )));
                                })
                        ])),
                  )
                ],
              )
            ],
          )),
    );
  }
}
