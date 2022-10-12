import 'package:flutter/material.dart';
import 'package:flutterdemo02/componentsShopcar/shopcarAppBar.dart';

class emptyShopCar extends StatelessWidget {
  const emptyShopCar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shopcarAppBar(),
      body: const Center(child: Text('您還沒點餐唷')),
    );
  }
}
