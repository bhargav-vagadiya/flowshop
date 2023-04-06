import 'dart:developer';

import 'package:flowshop/Constants/Constant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker_free/map_picker_free.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  List<Marker> _markers = [];
  bool mapLoaded = false;
  CameraPosition? cameraPosition;

  Future<CameraPosition?> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) => null)
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    var position = await Geolocator.getCurrentPosition();
    cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 17);
    _markers = <Marker>[
      Marker(
          markerId: MarkerId('1'),
          position: cameraPosition!.target,
          infoWindow: InfoWindow(
            title: 'My Position',
          )),
    ];
    setState(() {
      mapLoaded = true;
    });
    return cameraPosition;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Select Location"),

        ),
        body: mapLoaded
            ? MapPicker(
                primaryColor: brown,
                center: LatLong(cameraPosition!.target.latitude,
                    cameraPosition!.target.longitude),
                onPicked: (data) {
                  log(data.address);
                  Navigator.pop(context,data.address);
                })
            : Container());
  }
}
