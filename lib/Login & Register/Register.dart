import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flowshop/Login%20&%20Register/otp.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final bool isSeller;
  const Register({super.key, required this.isSeller});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: darkbrown,
                ),
                Text(
                  "Back",
                  style:
                      TextStyle(color: darkbrown, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30.0.h,
              ),
              child: Center(
                child: Text(
                  "Join Us",
                  style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: brown),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Image.asset(
              "images/splash_flower.png",
              height: 100.sp,
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Text(
                "Enter your mobile number",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                    color: darkbrown),
              ),
            ),
            Center(
              child: Text(
                "And we will send you the code",
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)
                ],
                onChanged: (value) => formKey.currentState!.validate(),
                decoration: InputDecoration(
                    counterText: "",
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: darkbrown)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: darkbrown)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: "Phone Number",
                    hintStyle: TextStyle(fontSize: 20.sp)),
                validator: (value) {
                  if (value!.length != 10) {
                    return "please enter 10 digit mobile number";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.all(10.0.sp),
              child: ElevatedButton(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 60))),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bool status = await context
                          .read<UserProvider>()
                          .checkUserIsRegistered(
                              phone: phoneController.text,
                              isSeller: widget.isSeller);
                      if (status == false && mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTP(
                                      phoneNumber: phoneController.text,
                                      isSeller: widget.isSeller,
                                    )));
                      }
                    }
                  },
                  child: context.watch<UserProvider>().loading
                      ? CircularProgressIndicator()
                      : const Text("Get OTP")),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "already have an account? ",
                      style: TextStyle(
                          color: brown,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                      children: [
                    TextSpan(
                        text: "Log in",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login(
                                          isSeller: widget.isSeller,
                                        )));
                          })
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
