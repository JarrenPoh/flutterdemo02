import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/StoreModel.dart';
import 'package:flutterdemo02/components3/components3_second/image_map.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class mainList extends StatefulWidget {
  mainList({
    Key? key,
    required this.data,
  }) : super(key: key);
  List<Result> data;

  @override
  State<mainList> createState() => _mainListState(
        data: data,
      );
}

class _mainListState extends State<mainList> {
  final cartController = Get.put(CartController());
  _mainListState({
    required this.data,
  });

  List<Result> data;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(data.length, (index) {
          bool businessTime;
          int selectedHour = TimeOfDay.now().hour;
          if (data[index].businessTime![selectedHour]==true) {
            print('營業中');
            businessTime = true;
          } else {
            print('尚未營業');
            businessTime = false;
          }
          return imageItems(
            timeEstimate: data[index].timeEstimate,
            businessTime: businessTime,
            discount: jsonDecode(data[index].discount!),
            name: data[index].name!,
            address: data[index].address,
            image: data[index].image,
            press: () async {
              if (cartController.cartlist.isNotEmpty &&
                  cartController.cartlist.first.shopname != data[index].name) {
                bool? delete = await showDeleteDialod();
                if (delete == false) {
                  Navigator.pushNamed(
                    context,
                    '/form4',
                    arguments: {
                      'shopname': data[index].name,
                      'shopimage': data[index].image,
                      'discount': jsonDecode(data[index].discount!),
                      'id': data[index].id,
                      'businessTime': data[index].businessTime,
                      'timeEstimate': data[index].timeEstimate,
                      'describe': data[index].describe,
                    },
                  );
                  cartController.deleteAll();
                }
              } else {
                Navigator.pushNamed(
                  context,
                  '/form4',
                  arguments: {
                    'shopname': data[index].name,
                    'shopimage': data[index].image,
                    'discount': jsonDecode(data[index].discount!),
                    'id': data[index].id,
                    'businessTime':  data[index].businessTime,
                    'timeEstimate': data[index].timeEstimate,
                    'describe': data[index].describe,
                  },
                );
              }
            },
          );
        }),
      ),
    );
  }

  Future<bool?> showDeleteDialod() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text('您選擇了不同餐廳，確認是否清除目前購物車內容'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('確認'),
            ),
          ],
        );
      },
    );
  }
}
