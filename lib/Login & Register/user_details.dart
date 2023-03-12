import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/models/user_model.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class UserDetails extends StatefulWidget {
  bool update;
  String? phoneNumber;

  UserDetails({Key? key, required this.update, this.phoneNumber})
      : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool passwordVisible = false, confirmPasswordVisible = false;
  static bool process = false;
  TextEditingController phone = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  getUserData() async {
    var db = await DbHelper.initdatabase();
    Map result = await DbHelper.getUserData(db);
    phone.text = result['mobile_number'];
    firstname.text = result['first_name'];
    lastname.text = result['last_name'];
    address.text = result['address'];
  }

  @override
  initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      phone.text = widget.phoneNumber!;
    }
    if (widget.update) getUserData();
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
                      "Back",
                      style: TextStyle(
                          color: darkbrown, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              elevation: 0,
              backgroundColor: creamColor),
          body: Stack(
            children: [
              // Container(
              //   decoration: const BoxDecoration(
              //       image: DecorationImage(
              //           image: AssetImage(backgroundImage), fit: BoxFit.fill)),
              // ),
              // Positioned(
              //   top: 40,
              //   left: -25,
              //   child: Row(
              //     children: [
              //       Image.asset("images/icons/Line1.png"),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Image.asset("images/icons/RepeatGrid1.png"),
              //     ],
              //   ),
              // ),
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 40.0, left: 40),
                    child: Text(
                      widget.update ? "Update Profile" : "Enter Your Details",
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: brown),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 40, top: 20),
                      decoration: BoxDecoration(
                          color: brownTransperent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          TextField(
                            controller: phone,
                            enabled: false,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[+ ]"),
                                  allow: false)
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "Phone Number",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 20)),
                            cursorColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: firstname,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "First Name",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 20)),
                            cursorColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: lastname,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 20)),
                            cursorColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: address,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {},
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.white.withOpacity(0.50),
                                    )),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "Address",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 20)),
                            cursorColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: email,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: "Email address",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.70),
                                    fontSize: 20)),
                            cursorColor: Colors.white,
                          ),
                          Visibility(
                              visible: !widget.update,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: password,
                                    obscureText: !passwordVisible,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible =
                                                    !passwordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove_red_eye,
                                              color: passwordVisible
                                                  ? brown
                                                  : Colors.white
                                                      .withOpacity(0.50),
                                            )),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.70),
                                            fontSize: 20)),
                                    cursorColor: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: confirmPassword,
                                    obscureText: !confirmPasswordVisible,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                confirmPasswordVisible =
                                                    !confirmPasswordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.remove_red_eye,
                                              color: confirmPasswordVisible
                                                  ? brown
                                                  : Colors.white
                                                      .withOpacity(0.50),
                                            )),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.70),
                                            fontSize: 20)),
                                    cursorColor: Colors.white,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: ElevatedButton(
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 60))),
                    onPressed: () async {
                      if (phone.text.trim().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please enter phone number");
                      } else if (firstname.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter first name");
                      } else if (lastname.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter last name");
                      } else if (address.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter address");
                      } else if (email.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please enter email address");
                      } else if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email.text.trim()) ==
                          false) {
                        Fluttertoast.showToast(msg: "Invalid email address");
                      } else if (widget.update == false) {
                        if (password.text.trim().isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter password");
                        } else if (confirmPassword.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please enter confirm password");
                        } else if (password.text.trim() !=
                            confirmPassword.text.trim()) {
                          Fluttertoast.showToast(
                              msg:
                                  "Password and confirm password didn't match");
                        } else {
                          bool status = await context
                              .read<UserProvider>()
                              .registerUser(
                                  userModel: UserModel(
                                      firstName: firstname.text.trim(),
                                      lastName: lastname.text.trim(),
                                      phone: phone.text.trim(),
                                      address: address.text.trim(),
                                      password: password.text.trim(),
                                      email: email.text.trim()));
                          if (status && mounted) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          }
                        }
                      } else {
                        Database db = await DbHelper.initdatabase();
                        bool result = await DbHelper.updateUserData(
                            db,
                            phone.text.trim(),
                            firstname.text.trim(),
                            lastname.text.trim(),
                            address.text.trim());

                        if (result == true) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: context.watch<UserProvider>().loading
                        ? CircularProgressIndicator()
                        : Text(
                            widget.update ? "Update" : "Sign in",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffe9c858)),
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
