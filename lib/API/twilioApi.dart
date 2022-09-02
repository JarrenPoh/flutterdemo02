import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class twilioApi {
  static Future<String?> getSMS(key) async {
    var response = await http.post(
        Uri.parse(
            "https://hello-cycu-delivery-service.herokuapp.com/member/twilio/send"),
        headers: {
          "token": key,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    print("this is response ${response}");
    print("this is response body ${response.body}");
    var obj = jsonDecode(response.body);
    print("this is response ${response.statusCode}");
    print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");
    if (response.statusCode == 200) {
      return obj['status'];
    } else if (response.statusCode == 403) {
      return null;
    }else {
      return obj['result'];
    }
  }

  static Future<String?> getVerify(key, code) async {
    var response = await http.post(
        Uri.parse(
            "https://hello-cycu-delivery-service.herokuapp.com/member/twilio/verify"),
        headers: {
          "token": key,
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "code": code,
        });

    print("this is response ${response}");
    print("this is code ${code}");
    print("this is response body ${response.body}");
    var obj = jsonDecode(response.body);
    print("this is response ${response.statusCode}");
    print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");

    if (response.statusCode == 200) {
      return obj['result'];
    } else if (response.statusCode == 403) {
      return null;
    }else {
      return obj['result'];
    }
  }
}
