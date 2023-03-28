import 'dart:io';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flowshop/api_handler/user_handler.dart';
import 'package:flowshop/models/product_model.dart';
import 'package:flowshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  final bool isUpdate;
  final ProductModel? productModel;
  const AddProduct({super.key, required this.isUpdate, this.productModel});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool imagePickedAfterUpdate = false;
  void getProductDetals() {
    imagePath = widget.productModel?.imageUrl ?? "";
    flowerName.text = widget.productModel!.name;
    flowerDescription.text = widget.productModel!.description;
    flowerType.text = widget.productModel!.flowerType;
    flowerQuantity.text = widget.productModel!.quantity.toString();
    flowerPrice.text = widget.productModel!.price.toString();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isUpdate) getProductDetals();
    super.initState();
  }

  ImageProvider? image() {
    if (imagePath != "") {
      if (widget.isUpdate && !imagePickedAfterUpdate) {
        return NetworkImage(imagePath);
      } else {
        return FileImage(File(imagePath));
      }
    }
    return null;
  }

  TextEditingController flowerName = TextEditingController();
  TextEditingController flowerDescription = TextEditingController();
  TextEditingController flowerType = TextEditingController();
  TextEditingController flowerQuantity = TextEditingController();
  TextEditingController flowerPrice = TextEditingController();

  String imagePath = "";
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
              Center(
                child: GestureDetector(
                  onTap: () async {
                    var picker = ImagePicker();
                    var pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        imagePath = pickedFile.path;
                        imagePickedAfterUpdate = true;
                      });
                    }
                  },
                  child: SizedBox(
                    height: 80.h,
                    width: 80.w,
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 50.r,
                            backgroundColor: creamColor,
                            foregroundImage: image(),
                            child: Icon(
                              Icons.image,
                              color: brown,
                              size: 50.sp,
                            )),
                        if (imagePath == "")
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                    color: brown,
                                    borderRadius: BorderRadius.circular(20.r)),
                                child: const Center(
                                    child: Icon(
                                  Icons.add,
                                  color: creamColor,
                                ))),
                          )
                      ],
                    ),
                  ),
                ),
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
                controller: flowerName,
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
                controller: flowerDescription,
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
                controller: flowerType,
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
                controller: flowerQuantity,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                controller: flowerPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Enter flower price",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brown),
                        borderRadius: BorderRadius.circular(30.r))),
              ),
              SizedBox(
                height: 60.h,
              )
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40.h,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (flowerName.text.isNotEmpty &&
                            flowerDescription.text.isNotEmpty &&
                            flowerType.text.isNotEmpty &&
                            flowerQuantity.text.isNotEmpty &&
                            flowerPrice.text.isNotEmpty &&
                            imagePath != "") {
                          var model = ProductModel(
                              id: widget.isUpdate ? widget.productModel!.id : 0,
                              name: flowerName.text,
                              description: flowerDescription.text,
                              flowerType: flowerType.text,
                              quantity: int.parse(flowerQuantity.text),
                              price: double.parse(flowerPrice.text),
                              sellerId: await UserHandler.getSellerId(),
                              imageUrl: imagePath);

                          var provider = Provider.of<ProductProvider>(context,
                              listen: false);

                          var result = widget.isUpdate
                              ? await provider.updateProduct(model)
                              : await provider.addProduct(model);
                          if (result && mounted) {
                            Navigator.pop(context);
                          }
                        } else {
                          if (imagePath == "") {
                            Fluttertoast.showToast(msg: "please upload image");
                          }
                          Fluttertoast.showToast(
                              msg: "all fields are compulsory");
                        }
                      },
                      child: Text("Submit")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
