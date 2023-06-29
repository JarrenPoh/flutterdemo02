import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class loginApi {
  static Future<http.Response?> getGoogleUsers(key) async {
    var response = await http.post(
      Uri.parse("https://www.foodone.tw/member/google/mlogin"),
      headers: {
        "google_token": key,
        "Content-Type": "application/x-www-form-urlencoded"
      },
    );
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

  static Future<http.Response?> getAppleUsers(email, password) async {
    var response = await http.post(
      Uri.parse("https://www.foodone.tw/member/login"),
      body: {
        "email": email,
        "password": password,
      },
    );
    print("getAppleUsers statuscode in loginApi ${response.statusCode}");
    print("getAppleUsers responseBody in loginApi ${response.body}");
    print("getAppleUsers headers in loginApi ${response.headers}");
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }

  static Future<http.Response?> registerAppleUsers(name, email, password) async {
    var response = await http.post(
      Uri.parse("https://www.foodone.tw/member/register"),
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
    print("register statuscode in loginApi ${response.statusCode}");
    print("register responseBody in loginApi ${response.body}");
    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }
}
