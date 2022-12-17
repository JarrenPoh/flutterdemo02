import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class loginApi {
  loginApi({required this.token});
  String token;
  static Future<http.Response?> getUsers(key) async {
    var response = await http.post(
        Uri.parse(
            "https://www.foodone.tw/member/google/mlogin"),
        headers: {
          "google_token": key,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    print("this is statuscode in loginApi ${response.statusCode}");
    print("this is responseBody in loginApi ${response.body}");

    // print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }
}
