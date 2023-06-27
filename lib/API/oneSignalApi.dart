import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'StoreModel.dart';

class OneSignalapi {
  static Future<String?> getOneSignal(String appID, token) async {
    final response = await http.post(
      Uri.parse(
          'https://www.foodone.tw/member/onesignal/subscribe'),
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
    if (response.statusCode == 200) {
      UserSimplePreferences.setOneSignalApiDone(true);
      return 'success';
    } else if (response.statusCode == 403) {
      return 'failed';
    } else {
      return 'failed';
    }
  }
}
