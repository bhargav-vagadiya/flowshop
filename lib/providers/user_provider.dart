import 'package:flowshop/DbHelper/DbHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider extends ChangeNotifier {
  bool loading = true;
  void registerUser(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required String password}) async {
    try {
      Database data = await DbHelper.initdatabase();
      bool result = await DbHelper.insertUser(data, firstName.trim(),
          lastName.trim(), phoneNumber.trim(), address.trim(), password.trim());
      if (result == true) {
        // ignore: use_build_context_synchronously
       loading = false;
       notifyListeners();
      }
    } on Exception catch (e) {
      // TODO
      if (kDebugMode) {
        print(e);
      }
      Fluttertoast.showToast(msg: "Please try after some time");
      loading = false;
      notifyListeners();
    }
  }
}
