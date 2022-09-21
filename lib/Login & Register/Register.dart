import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  bool update;

  Register({Key? key, required this.update}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordVisible = false, confirmPasswordVisible = false;
  static bool process = false;
  TextEditingController phone = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController address = TextEditingController();
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
    if (widget.update) getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(fontFamily: "Squre",elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(brown))),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),),
      child: Scaffold(
          body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.fill)),
          ),
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
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.0, left: 40),
                child: Text(
                  widget.update ? "Update Profile" : "Join Us",
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold, color: brown),
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
                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                      TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
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
                                borderSide: BorderSide(color: Colors.white)),
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
                                borderSide: BorderSide(color: Colors.white)),
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
                                onPressed: () async {
                                  loc.LocationData mylocation;
                                  loc.Location location = loc.Location();
                                  try {
                                    mylocation = await location.getLocation();
                                    print(
                                        "${mylocation.latitude} ${mylocation.longitude}");
                                    List<Placemark> placemarks =
                                        await placemarkFromCoordinates(
                                            mylocation.latitude.toDouble(),
                                            mylocation.longitude.toDouble());
                                    var place = placemarks[0];
                                    address.text =
                                        '${place.name}, ${place.locality}, ${place.country}, ${place.postalCode}';
                                    setState(() {

                                    });
                                  } on PlatformException catch (e) {
                                    if (e.code == 'PERMISSION_DENIED') {
                                      Fluttertoast.showToast(
                                          msg: "please grant permission");
                                    }
                                    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
                                      Fluttertoast.showToast(
                                          msg:
                                              "permission denied- please enable it from app settings");
                                    }
                                  }catch(e){
                                    print(e);
                                  }
                                },
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.white.withOpacity(0.50),
                                )),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Address",
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
                                              : Colors.white.withOpacity(0.50),
                                        )),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.70),
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
                    minimumSize: MaterialStateProperty.all(const Size(200, 60))),
                onPressed: () async {
                  if (phone.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please Enter Phone Number");
                  } else if (firstname.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please Enter First Name");
                  } else if (lastname.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: "Please Enter Last Name");
                  } else if (address.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please Enter Address");
                  } else if (widget.update == false) {
                    if (password.text.trim().isEmpty) {
                      Fluttertoast.showToast(msg: "Please Enter Password");
                    } else if (confirmPassword.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter Confirm Password");
                    } else if (password.text.trim() !=
                        confirmPassword.text.trim()) {
                      Fluttertoast.showToast(
                          msg: "Password and Confirm Password didn't match");
                    } else {
                      setState(() {
                        process = true;
                      });
                      try {
                        Database data = await DbHelper.initdatabase();
                        bool result = await DbHelper.insertUser(
                            data,
                            firstname.text.trim(),
                            lastname.text.trim(),
                            phone.text.trim(),
                            address.text.trim(),
                            password.text.trim());
                        if (result == true) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      } on Exception catch (e) {
                        // TODO
                        if (kDebugMode) {
                          print(e);
                        }
                        Fluttertoast.showToast(msg: "Please try after some time");
                      }
                      setState(() {
                        process = false;
                      });
                    }
                  } else {
                    Database db = await DbHelper.initdatabase();
                    bool result = await DbHelper.updateUserData(
                        db,
                        phone.text.trim(),
                        firstname.text.trim(),
                        lastname.text.trim(),
                        address.text.trim());
                    
                    if(result==true){
                     Navigator.pop(context);
                    }
                  }

                },
                child: process
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
