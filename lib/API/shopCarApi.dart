import 'package:flutter/widgets.dart';
import 'package:flutterdemo02/API/shopCarModel.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../controllers/cart_controller.dart';

class shopCarApi {
  shopCarApi({required this.token});
  String token;
  static Future<Result?> getCar(key) async {
    final CartController cartController = Get.find();
    print(
        'this is cartController.options() in shopCarApi ${cartController.options()}');
    var response = await http.post(
      Uri.parse(
          "https://hello-cycu-delivery-service.herokuapp.com/member/user/order"),
      headers: {
        "token": key,
        "Content-Type": "application/json",
      },
      body: cartController.options(),
    );
    // print("this is response ${response}");
    // print("this is response ${response.body}");

    // print("this is response headers ${response.headers}");
    // print("this is refresh_token ${response.headers['refresh_token']}");
    debugPrint('the statuscode in shopCarApi is ${response.statusCode}');
    debugPrint('the body in shopCarApi is ${response.body}');
    if (response.statusCode == 201) {
      print('${response.body}');
      var obj = Autogenerated.fromJson(jsonDecode(response.body));

      var myaddress = (obj.result);

      debugPrint('statuscode is ${response.statusCode}');
      return myaddress;
    } else if (response.statusCode == 403) {
      debugPrint('statuscode is ${response.statusCode}');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }
}
