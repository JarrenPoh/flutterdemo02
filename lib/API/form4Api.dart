import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'MenuModel.dart';

class MenuApi {
  MenuApi({required this.id, required this.token});
  String id, token;
  static Future<List<Result?>?> getMenus(id, token) async {
    final response = await http.get(
        Uri.parse(
            'https://hello-cycu-delivery-service.herokuapp.com/member/store/product'),
        headers: {
          "token": token,
          "Content-Type": "application/x-www-form-urlencoded",
          "id": id,
        });

    if (response.statusCode == 200) {
      print('status in form4${response.statusCode}');

      print('${response.body}');
      var obj = Menu.fromJson(jsonDecode(response.body));

      var myaddress = (obj.result as List<Result?>);

      return myaddress;
    } else if (response.statusCode == 403) {
      print('status in form4${response.statusCode}');
      return null;
    } else {
      debugPrint('Failed to load store');
      throw Exception('Failed to load store');
    }
  }
}