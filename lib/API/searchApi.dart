import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'StoreModel.dart';

class BookApi {
  static Future<List<Result?>?> getStores(String query, token) async {
    final response = await http.get(
        Uri.parse(
            'https://www.foodone.tw/member/store'),
        headers: {
          "token": token,
          "Content-Type": "application/x-www-form-urlencoded"
        });
    print('response body in searchApi is ${response.body}');
    if (response.statusCode == 200) {
      var obj = Store.fromJson(jsonDecode(response.body));
      var myaddress = (obj.result as List<Result?>);
      return myaddress.map((json) => json).where((element) {
        final titleLower = element!.name.toString().toLowerCase();
        final addressLower = element.address.toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            addressLower.contains(searchLower);
      }).toList();
    } else if (response.statusCode == 403) {
      print('statusCode in searchApi is${response.statusCode}');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }
}
