import 'package:dio/dio.dart';

class DioConfig {
  var dio = Dio();
  DioConfig() {
    dio.options.baseUrl = "http://20.219.59.136:3000/";
    dio.options.connectTimeout = const Duration(seconds: 5);
  }
}
