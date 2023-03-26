import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flowshop/Login%20&%20Register/buyer_details.dart';
import 'package:flowshop/Login%20&%20Register/seller_details.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OTP extends StatefulWidget {
  final String phoneNumber;
  final bool isSeller;

  const OTP({Key? key, required this.phoneNumber, required this.isSeller})
      : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  var firebaseAuth = FirebaseAuth.instance;
  String verificationId = "", smsCode = "";
  int resendOTPCountDown = 30;

  Future<void> sendCode() async {
    setState(() {
      resendOTPCountDown = 30;
    });
    timer();
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        verificationCompleted: (credential) {},
        verificationFailed: (e) {},
        codeSent: (verificationId, code) {
          print("code sent");
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (time) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendCode();
  }

  timer() async {
    while (resendOTPCountDown != 0) {
      if (resendOTPCountDown <= 0) break;
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        resendOTPCountDown--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: darkbrown,
                ),
                Text(
                  "Cancel",
                  style:
                      TextStyle(color: darkbrown, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          leadingWidth: 100,
          elevation: 0,
          backgroundColor: creamColor),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            const Text(
              "Enter Code",
              style: TextStyle(
                  fontSize: 45, fontWeight: FontWeight.bold, color: darkbrown),
            ),
            const Spacer(
              flex: 3,
            ),
            OtpTextField(
              enabledBorderColor: darkbrown,
              numberOfFields: 6,
              showFieldAsBox: true,
              onSubmit: (value) {
                setState(() {
                  smsCode = value;
                });
              },
            ),
            const Spacer(
              flex: 5,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size(200, 60))),
                onPressed: () async {
                  if (smsCode.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter code"),
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    AuthCredential authCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);
                    try {
                      UserCredential? user = await firebaseAuth
                          .signInWithCredential(authCredential);
                      if (mounted) {
                        if (widget.isSeller) {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellerDetails(
                                        update: false,
                                        phoneNumber: widget.phoneNumber,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuyerDetails(
                                        update: false,
                                        phoneNumber: widget.phoneNumber,
                                      )));
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.message!),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
                child: Text("Confirm",
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffe9c858)))),
            const Spacer(
              flex: 1,
            ),
            Text.rich(TextSpan(children: [
              const TextSpan(
                  text: "Didn't received code? ",
                  style: TextStyle(color: brown)),
              TextSpan(
                  text: resendOTPCountDown > 0
                      ? resendOTPCountDown.toString()
                      : "Resend",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (resendOTPCountDown <= 0) {
                        sendCode();
                      }
                    },
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: darkbrown))
            ])),
            const Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
