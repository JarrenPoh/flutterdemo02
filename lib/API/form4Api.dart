import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'MenuModel.dart';

class MenuApi {
  MenuApi({required this.id, required this.token});
  String id, token;
  static Future<Result3?> getMenus(id, token) async {
    final response = await http.post(
        Uri.parse(
            'https://www.foodone.tw/member/store/detail'),
        headers: {
          "token": token,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "id": id,
        });
    print('status in form4 ${response.statusCode}');

    print('${response.body}');
    var obj = (jsonDecode(response.body));
    Result3? myaddress = MenuAutogenerated.fromJson(obj).result;
    if (response.statusCode == 200) {
      return myaddress;
    } else if (response.statusCode == 403) {
      print('status in form4 ${response.statusCode}');
      return null;
    } else {
      debugPrint('Failed to load store');
      throw Exception('Failed to load store');
    }
  }
}
