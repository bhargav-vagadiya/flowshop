import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> initdatabase() async {
    var getdbpath = await getDatabasesPath();
    String dbpath = "$getdbpath/flowshop.db";
    Database database;
    database = await openDatabase(dbpath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""Create table Users(
                    user_id integer primary key autoincrement,
                    first_name text,
                    last_name text,
                    mobile_number text unique,
                    address text,
                    password text)""");

      await db.execute("""Create table Product(
                    product_id integer primary key autoincrement,
                    product_name text,
                    image_path text,
                    price int unique,
                    description text,
                    ratings text)""");

      await db.execute("""Create table Cart(
                    cart_id integer primary key autoincrement,
                    product_id integer,
                    user_id integer,
                    foreign key(product_id) references Product(product_id),
                    foreign key(user_id) references Users(user_id))""");

      await db.execute("""Create table Orders(
                    order_id integer primary key autoincrement,
                    cart_id integer,
                    payment_mode text,
                    buying_time text,
                    order_received_time text,
                    order_confirm_time text,
                    out_of_delivery_time text,
                    foreign key(cart_id) references Cart(cart_id))""");
    });
    return database;
  }

  static insertUser(Database db, String firstName, String lastName,
      String mobileNumber, String address, String password) async {
    List<Map<String, Object?>> result = await db
        .rawQuery("select * from Users where mobile_number='$mobileNumber'");
    if (result.isEmpty) {
      try {
        await db.execute(
            "insert into Users(first_name,last_name,mobile_number,address,password) values('$firstName','$lastName','$mobileNumber','$address','$password')");
        Fluttertoast.showToast(msg: "Registration Successful");
        return true;
      } on Exception catch (e) {
        Fluttertoast.showToast(msg: "please try after some time");
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: "User already Exists");
      return false;
    }
  }

  static checkUser(Database db, String username, String password) async {
    try {
      List<Map<String, Object?>> result = await db.rawQuery(
          "select * from Users where mobile_number='$username' and password='$password'");

      if (result.isEmpty) {
        List<Map<String, Object?>> result = await db
            .rawQuery("select * from Users where mobile_number='$username'");
        print(result);
        if (result.isEmpty) {
          Fluttertoast.showToast(msg: "User does not Exists");
          return false;
        } else {
          Fluttertoast.showToast(msg: "Password incorrect");
          return false;
        }
      } else {
        if (kDebugMode) {
          print(result);
        }
        Fluttertoast.showToast(
            msg:
                "Welcome ${result[0]['first_name']} ${result[0]['last_name']}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            "UserName", "${result[0]['first_name']} ${result[0]['last_name']}");
        prefs.setString("id", "${result[0]['user_id']}");
        return true;
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "something went wrong");
      return false;
    }
  }

  static getUserData(Database db) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    List<Map> result =
        await db.rawQuery("select * from users where user_id=$id");
    return {
      "mobile_number": result[0]['mobile_number'],
      "first_name": result[0]['first_name'],
      "last_name": result[0]['last_name'],
      "address": result[0]['address']
    };
  }

  static updateUserData(Database db, String mobileNumber, String firstName,
      String lastName, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    try{
      await db.rawUpdate(
          "update Users set mobile_number='$mobileNumber',first_name='$firstName',last_name='$lastName',address='$address' where user_id=$id");
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
      return true;
    }catch(e){
      Fluttertoast.showToast(msg: "This mobile number is registered to other user.");
      if (kDebugMode) {
        print(e);
      }
      return false;
    }

  }
}
