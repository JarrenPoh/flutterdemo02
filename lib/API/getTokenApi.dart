import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class getTokenApi {
  getTokenApi({required this.token});
  String token;
  static Future<http.Response> getToken(key) async {
    var response = await http.get(
        Uri.parse(
            "https://hello-cycu-delivery-service.herokuapp.com/member/user/token"),
        headers: {
          "refresh_token": key,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    debugPrint("status code on getTokenApi is  ${response.statusCode}");
    debugPrint("status body on getTokenApi is  ${response.body}");
    // print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");
    // print("7777${response.body}");
    // print(response.headers['token']);

    return response;
  }
}
