import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChangePassword extends StatefulWidget {
  bool isSeller;

  ChangePassword({Key? key, required this.isSeller}) : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool passwordVisible = false,
      oldPasswordVisible = false,
      newPasswordVisible = false;
  TextEditingController username = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool process = false;

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
                      "Change Password",
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
                              controller: oldPassword,
                              obscureText: !oldPasswordVisible,
                              enableSuggestions: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          oldPasswordVisible =
                                              !oldPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: oldPasswordVisible
                                            ? brown
                                            : Colors.white.withOpacity(0.50),
                                      )),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: "Old Password",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 17.sp)),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.visiblePassword,
                              autofillHints: const [AutofillHints.password],
                              onEditingComplete: () =>
                                  TextInput.finishAutofillContext(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: newPassword,
                              obscureText: !newPasswordVisible,
                              enableSuggestions: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          newPasswordVisible =
                                              !newPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: newPasswordVisible
                                            ? brown
                                            : Colors.white.withOpacity(0.50),
                                      )),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: "New Password",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 17.sp)),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.visiblePassword,
                              autofillHints: const [AutofillHints.password],
                              onEditingComplete: () =>
                                  TextInput.finishAutofillContext(),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            TextField(
                              controller: confirmPassword,
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
                                  hintText: "Confirm New Password",
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
                      if (oldPassword.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "please enter old confirmPassword");
                      } else if (newPassword.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "please enter new confirmPassword");
                      } else if (confirmPassword.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "please enter new confirm confirmPassword");
                      } else if (newPassword.text.trim() !=
                          confirmPassword.text.trim()) {
                        Fluttertoast.showToast(msg: "Password didn't match");
                      } else {
                        bool result = await context
                            .read<UserProvider>()
                            .updateUserPassword(
                                isSeller: widget.isSeller,
                                oldPassword: oldPassword.text.trim(),
                                newPassword: newPassword.text.trim());

                        if (kDebugMode) {
                          print(result);
                        }
                        if (result) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: context.watch<UserProvider>().loading
                        ? const CircularProgressIndicator()
                        : Text(
                            "Change Password",
                            style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffe9c858)),
                          ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          )),
    );
  }
}
