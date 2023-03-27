import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/Login%20&%20Register/Login.dart';
import 'package:flowshop/Login%20&%20Register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    animation = AlignmentGeometryTween(
            begin: Alignment.centerLeft, end: Alignment.centerRight)
        .animate(animationController!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: ListView(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Welcome to,",
                style: TextStyle(
                  fontSize: 35.sp,
                  color: brown,
                ),
              ),
              Text(
                "Flowshop",
                style: TextStyle(
                    fontSize: 30.sp, color: brown, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Center(
                child: SizedBox(
                    height: 150.h,
                    width: 150.w,
                    child: Image.asset(
                      "images/splash_flower.png",
                    )),
              ),
              Spacer(),
              Text(
                "Are you?",
                style: TextStyle(
                    fontSize: 30.sp, color: brown, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Container(
                    decoration: BoxDecoration(
                        color: brown.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                            alignment: animation?.value,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: brown,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 50.h,
                            )),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  animationController?.reverse();
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.2,
                                height: 50.h,
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    "Buyer",
                                    style: TextStyle(
                                        color: animation!.value ==
                                                Alignment.centerLeft
                                            ? Colors.white
                                            : brown,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  animationController?.forward();
                                });
                              },
                              child: Container(
                                height: 50.h,
                                color: Colors.transparent,
                                width:
                                    MediaQuery.of(context).size.width / 2.235,
                                child: Center(
                                  child: Text(
                                    "Seller",
                                    style: TextStyle(
                                        color: animation!.value ==
                                                Alignment.centerRight
                                            ? Colors.white
                                            : brown,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.setString(
                      "roleType",
                      animation!.value == Alignment.centerLeft
                          ? "buyer"
                          : "seller");
                  if (mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  isSeller:
                                      animation!.value == Alignment.centerLeft
                                          ? false
                                          : true,
                                )));
                  }
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                            color: darkbrown,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: darkbrown,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              )
              // Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
