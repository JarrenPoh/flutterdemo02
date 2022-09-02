import 'package:flutter/widgets.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class UserUpdateApi {
  static Future<http.Response?> putUsers(newData, later, token) async {
    print(newData);
    print(later);
    Map jsonMap = {};
    if (newData == null) {
      jsonMap = {
        "phone": later,
      };
    } else if (later == null) {
      jsonMap = {
        "birthday": newData,
      };
    } else {
      jsonMap = {
        "birthday": newData,
        "phone": later,
      };
    }


    var response = await http.put(
      Uri.parse("https://hello-cycu-delivery-service.herokuapp.com/member"),
      headers: ({
        "token": token,
        "Content-Type": "application/x-www-form-urlencoded"
      }),
      body: jsonMap,
    );
    // print("this is response ${response}");
    // print("this is response ${response.body}");

    // print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");

    if (response.statusCode == 200) {
      debugPrint('status code in PutuserUpdateApi is ${response.statusCode}');
      return response;
    } else if (response.statusCode == 403) {
      debugPrint('status code in PutuserUpdateApi is ${response.statusCode}');
      return null;
    } else {
      debugPrint('status code in PutuserUpdateApi is ${response.statusCode}');
    }
  }

  static Future<http.Response?> getUsers(token) async {
    var response = await http.get(
      Uri.parse(
          "https://hello-cycu-delivery-service.herokuapp.com/member/user/info"),
      headers: ({
        "token": token,
        "Content-Type": "application/x-www-form-urlencoded"
      }),
    );
    // print("this is response ${response}");
    // print("this is response ${response.body}");

    // print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");

    if (response.statusCode == 200) {
      var obj = (jsonDecode(response.body));
      debugPrint('result in GetuserUpdateApi is ${obj['result']}');
      debugPrint('status code in GetuserUpdateApi is ${response.statusCode}');
      return response;
    } else if (response.statusCode == 403) {
      debugPrint('status code in GetuserUpdateApi is ${response.statusCode}');
      return null;
    } else if (response.statusCode == 500) {
      debugPrint('status code in GetuserUpdateApi is ${response.statusCode}');
    }
  }
}
