import 'package:flowshop/Constants/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Product",
          style: TextStyle(color: darkbrown, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("images/icons/arrow-backward.webp")),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Stack(
          children: [
            ListView(children: [
              GestureDetector(
                onTap: () {
                  
                },
                child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: creamColor,
                    child: Icon(
                      Icons.image,
                      color: brown,
                      size: 50.sp,
                    )),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: Text(
                  "Flower Name:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextField(
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Enter flower name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brown),
                        borderRadius: BorderRadius.circular(30.r))),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: const Text(
                  "Flower Description:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextField(
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Enter flower description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brown),
                        borderRadius: BorderRadius.circular(30.r))),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: const Text(
                  "Flower Type:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter flower type",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brown),
                        borderRadius: BorderRadius.circular(30.r))),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: const Text(
                  "Flower Quantity:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter flower quantity",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brown),
                        borderRadius: BorderRadius.circular(30.r))),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: const Text(
                  "Flower Price:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Enter flower price",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brown),
                        borderRadius: BorderRadius.circular(30.r))),
              ),
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: () {}, child: Text("Next")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
