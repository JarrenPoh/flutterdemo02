import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'historyModel.dart';

class HistoryApi {
  HistoryApi({required this.token});
  String token;
  static Future<List<Result2?>?> getStores(token) async {
    final response = await http.get(
        Uri.parse(
            'https://hello-cycu-delivery-service.herokuapp.com/member/user/order'),
        headers: {
          "token": '$token',
          "Content-Type": "application/x-www-form-urlencoded"
        });

    // for (String i in aswww){
    //   debugPrint("this......$i");
    // }

    // var order = oorder.map((e) => e);

    if (response.statusCode == 200) {
      debugPrint('status${response.statusCode}');
      debugPrint('responsebody${response.body}');
      var obj = Autogenerated2.fromJson(jsonDecode(response.body));
      var myaddress = (obj.result as List<Result2?>);
      return myaddress;
    } else if (response.statusCode == 403) {
      debugPrint('status${response.statusCode}');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }
}