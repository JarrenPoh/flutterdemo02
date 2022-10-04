import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'StoreModel.dart';

class OneSignalapi {
  static Future<String?> getOneSignal(String appID, token) async {
    final response = await http.post(
      Uri.parse(
          'https://hello-cycu-delivery-service.herokuapp.com/member/onesignal/subscribe'),
      headers: {
        "token": token,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        "user_id": appID,
      },
    );
    print('statusCode in getOneSignal is${response.statusCode}');
    print('response body in getOneSignal is ${response.body}');
    print('appID is $appID');
    if (response.statusCode == 200) {
      return response.body[2];
    } else if (response.statusCode == 403) {
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }
}
