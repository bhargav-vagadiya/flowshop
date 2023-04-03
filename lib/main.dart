import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Splash/Splash.dart';
import 'package:flowshop/providers/cart_provider.dart';
import 'package:flowshop/providers/order_provider.dart';
import 'package:flowshop/providers/product_provider.dart';
import 'package:flowshop/providers/user_provider.dart';
import 'package:flowshop/providers/wishlist_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  if(Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  // FlutterError.onError = (details) {
  //   if (kDebugMode) {
  //     print("\x1B[33mwidget\x1B[0m");
  //     print(details);
  //   }
  // };
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // var db = await DbHelper.initdatabase();
  // DbHelper.getProductDetails(db);
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA-sV_Jf9qq9U1UvW8I6pqK768RwV3WmKc",
            appId: "1:125256286410:web:178e333da90554ff1ef433",
            messagingSenderId: "125256286410",
            projectId: "flowshop-248a6",
            authDomain: "flowshop-248a6.firebaseapp.com",
            storageBucket: "flowshop-248a6.appspot.com",
            measurementId: "G-NZR4RYH871"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => WishListProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: ScreenUtilInit(
          builder: (BuildContext context, Widget? child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FlowShop',
              theme: ThemeData(
                appBarTheme: AppBarTheme(foregroundColor: Colors.black),
                // textTheme: TextTheme(titleLarge: TextStyle(fontSize: 15),titleSmall: TextStyle(fontSize: 10),),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(brown))),
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(primary: brown),
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder()
                }),
              ),
              home: child,
            );
          },
          child: const Splash()),
    );
  }
}
