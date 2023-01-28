import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'StoreModel.dart';

class BooksApi {
  BooksApi({required this.token});
  String token;
  static Future<List<Result?>?> getStores(token) async {
    final http.Response? response = await http.get(
        Uri.parse(
            'https://www.foodone.tw/member/store'),
        headers: {
          "token": '$token',
          "Content-Type": "application/x-www-form-urlencoded"
        });
    print('response.body in Form3Api is ${response!.body}');
    if (response.statusCode == 200) {
      var obj = Store.fromJson(jsonDecode(response.body));
      var myaddress = (obj.result as List<Result?>);
            
    print('營業時間 is ${myaddress.first!.businessTime}');
      debugPrint('status200 in form3');
      return myaddress;
    } else if (response.statusCode == 403) {
      debugPrint('status403 in form3');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }
}
