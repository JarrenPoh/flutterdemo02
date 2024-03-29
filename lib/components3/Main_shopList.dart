import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/StoreModel.dart';
import 'package:flutterdemo02/components3/components3_second/image_map.dart';
import 'package:flutterdemo02/pages/Form4.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../provider/googleMapKey.dart';

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
  String imageUrl = '';
  _mainListState({
    required this.data,
  });

  List<Result> data;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(data.length, (index) {
          imageUrl = data[index].thumbnail == null
              ? foodoneBackImg
              : 'https://foodone-s3.s3.amazonaws.com/store/main/${data[index].id!}?${data[index].last_update}';
          bool businessTime;
          int? businessStartTime;
          int selectedHour = TimeOfDay.now().hour;
          data[index].businessTime!.forEach((element) {
            print(element);
          });

          if (data[index].businessTime![selectedHour] == true ||
              data[index].status! <= 180) {
            print('營業中');
            businessTime = true;
          } else {
            print('尚未營業');
            businessTime = false;
            for (int i = selectedHour;
                i < data[index].businessTime!.length;
                i++) {
              if (data[index].businessTime![i] == true) {
                businessStartTime = i;
                break;
              }
            }
            print('下一個營業時間為 $businessStartTime');
          }
          return imageItems(
            timeEstimate: data[index].timeEstimate,
            businessTime: businessTime,
            businessStartTime: businessStartTime,
            discount: jsonDecode(data[index].discount!),
            name: data[index].name!,
            address: data[index].address,
            image: imageUrl,
            id: data[index].id!,
            press: () async {
              if (cartController.cartlist.isNotEmpty &&
                  cartController.cartlist.first.shopname != data[index].name) {
                bool? delete = await showDeleteDialod();
                if (delete == false) {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      child: FormPage4(
                        arguments: {
                          'id': data[index].id,
                        },
                      ),
                    ),
                  );
                  cartController.deleteAll();
                }
              } else {
                Navigator.push(
                  context,
                  CustomPageRoute(
                    child: FormPage4(
                      arguments: {
                        'id': data[index].id,
                      },
                    ),
                  ),
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
