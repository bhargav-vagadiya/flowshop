import 'dart:async';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flowshop/Splash/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var db = await DbHelper.initdatabase();
  DbHelper.getProductDetails(db);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlowShop',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(foregroundColor: Colors.black),
        fontFamily: "Swis",
       // textTheme: TextTheme(titleLarge: TextStyle(fontSize: 15),titleSmall: TextStyle(fontSize: 10),),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(brown))),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.white),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
      ),
      home: const Splash(),
    );
  }
}
