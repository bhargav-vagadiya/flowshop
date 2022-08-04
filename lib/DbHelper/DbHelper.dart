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
                    product_name text unique,
                    image_path text,
                    qty int,
                    price int,
                    description text,
                    ratings text)""");

      await db.execute("""Create table WishList(
                    wishlist_id integer primary key autoincrement,
                    product_id integer,
                    user_id integer,
                    foreign key(product_id) references Product(product_id),
                    foreign key(user_id) references Users(user_id))""");

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
    }, onOpen: (Database db) async {
      try {
        await db.execute("DROP TABLE IF EXISTS Product");
        await db.execute("""Create table Product(
                    product_id integer primary key autoincrement,
                    product_name text unique,
                    image_path text,
                    qty int,
                    price int,
                    description text,
                    ratings text)""");
        await db.rawInsert(
            "insert into Product(product_name,image_path,qty,price,description) values('Mixed Bouquet Each','images/products/product2.webp',100,599,'This tantalizing need no decoration! Celebrate a spring birthday, send your love, or simply let someone know you are thinking of them with this stunning monochrome bouquet. Presented in a clear cylinder vase, the minimalist gift appeals to purple-lovers, tulip-devotees and those with a more elegant and simple sense of style.')");
        await db.rawInsert(
            "insert into Product(product_name,image_path,qty,price,description) values('Passionate Purple Tulips Bouquet','images/products/product1.webp',50,499,'Pure lovely. Long-stemmed purple tulips are a tantalizing treat in our shimmering mercury glass vase. This bouquet is a timeless symbol of your singular love.')");
        await db.rawInsert(
            "insert into Product(product_name,image_path,qty,price,description) values('Decorative Roses With Waxflower','images/products/product3.webp',70,549,'Just peachy! This soft, feminine bouquet of peach-colored spring flowers is presented in a French country ceramic pot with fleur-de-lis motif. The country style floral arrangement is a pretty way to send your best wishes.')");
        await db.rawInsert(
            "insert into Product(product_name,image_path,qty,price,description) values('Sun Kissed','images/products/product4.webp',40,399,'Sun Kissed is a sweet bud vase filled with spray roses and cheerful sunflowers! Sword ferns and ruscus balance out the beautiful, bright colors. These flowers are guaranteed to bring a smile to anyone’s face!')");
        if (kDebugMode) {
          print("product inserted😍");
        }
      } on Exception catch (e) {
        // TODO
        if (kDebugMode) {
          print("already inserted😒 $e");
        }
      }
    });
    return database;
  }

  static getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("id")!;
    return userId;
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

  static addWishlist(productId, userId) async {
    var db = await initdatabase();
    try {
     await db.execute(
          "insert into WishList(product_id,user_id)values($productId,$userId)");
      return true;
    } on Exception catch (e) {
      // TODO
      return false;
    }
  }

  static Future<bool> productInWishlist(productId, userId) async {
    var db = await initdatabase();
   try {
     var result = await db.rawQuery(
          "select * from Wishlist where product_id=$productId and user_id=$userId ");
     if(result.isNotEmpty){
       return true;
     }else{
       return false;
     }
   } on Exception catch (e) {
     // TODO
     return false;
   }
  }

  static getWishlistProducts(userId) async {
    var db = await initdatabase();
    try {
      var result = db.rawQuery(
          "select p.product_id,p.product_name,p.image_path,p.qty,p.price,p.description,u.user_id from Product p,Users u,Wishlist w where p.product_id=w.product_id and u.user_id=w.user_id and w.user_id=$userId");
      print(result);
      return result;
    } on Exception catch (e) {
      // TODO
    }
  }

  static removeWishlistByUser(proudctId,userId) async{
    var db = await initdatabase();
    try {
      db.rawDelete("delete from Wishlist where product_id=$proudctId and user_id=$userId");
      return true;
    } on Exception catch (e) {
      // TODO
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
    try {
      await db.rawUpdate(
          "update Users set mobile_number='$mobileNumber',first_name='$firstName',last_name='$lastName',address='$address' where user_id=$id");
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "This mobile number is registered to other user.");
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static changeUserPassword(
      Database db, String oldPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    try {
      var result =
          await db.rawQuery("select password from Users where user_id=$id");

      if (kDebugMode) {
        print(result[0]['password']);
      }
      if (oldPassword == result[0]['password'].toString().trim()) {
        await db.rawUpdate(
            "update Users set password='$newPassword' where user_id=$id");
        Fluttertoast.showToast(msg: "Password Updated Successfully");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Old Password is Incorrect");
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  static getProductDetails(Database db) async {
    var productData = await db.rawQuery("select * from Product");
    return productData;
  }

  static searchProduct(String searchText) async {
    var db = await initdatabase();
    var productData = await db.rawQuery(
        "select * from Product where product_name like '$searchText%'");
    print(productData);
    return productData;
  }
}
