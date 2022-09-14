import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/API/shopCarApi.dart';
import 'package:flutterdemo02/pages/Tabs.dart';
import 'package:get/get.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/shopCarModel.dart';
import '../models/cart_model.dart';
import '../provider/Shared_Preference.dart';

import 'package:http/http.dart' as http;

class CartController extends GetxController {
  List<CartModel> cartlist = <CartModel>[].obs;
  List<CartModel> newcartlist = <CartModel>[].obs;
  late CartModel cartModel;
  List<dynamic> radiolist = <dynamic>[].obs;
  List<dynamic> Radiolist = <dynamic>[].obs;
  bool tableware = false;
  
  String reservationTime = "${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${(TimeOfDay.now().minute).toString().padLeft(2, '0')}";
  late int finalPrice;
  bool ifUpdateCar = true;

  ////增加到購物車////
  void addProduct({
    required String id,
    required String name,
    required int price,
    required int quantity,
    required String shopname,
    String? description,
    String? image,
    required String textprice,
    List<List>? radiolist,
    List<String?>? radioTitleList,
    List<bool?>? radioMultiple,
    text,
    List<List>? addCheckBool,
    radioprices,
    radiopricesnum,
    options,
    requiredCheckBool,
    List<String?>? RadioTitleList,
    List<bool?>? RadioMultiple,
    List<List>? Radiolist,
    List? Radioprices,
    int? Radiopricesnum,
  }) {
    cartModel = CartModel(
      textprice: textprice,
      text: text,
      id: id,
      name: name,
      shopname: shopname,
      price: price,
      quantity: quantity,
      description: description,
      image: image,
      radiolist: radiolist,
      radioTitleList: radioTitleList,
      radioMultiple: radioMultiple,
      addCheckBool: addCheckBool,
      radioprices: radioprices,
      radiopricesnum: radiopricesnum,
      options: options,
      requiredCheckBool: requiredCheckBool,
      RadioTitleList: RadioTitleList,
      RadioMultiple: RadioMultiple,
      Radiolist: Radiolist,
      Radioprices: Radioprices,
      Radiopricesnum: Radiopricesnum,
    );
    if (updateDeleteIndex != null) {
      cartlist.insert(updateDeleteIndex, (cartModel));
    } else {
      cartlist.add(cartModel);
    }

    Get.snackbar(
      "添加成功",
      "您已新增 $quantity 項產品",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  ////檢測購物車有無更新///
  bool ifUpdate({required bool name}) {
    ifUpdateCar = name;
    return ifUpdateCar;
  }
  //////////

  ///////////
  get throwCartList {
    return cartlist;
  }

  ////購物車總價錢////
  int totalprice() {
    var total = 0;
    for (var element in cartlist) {
      total += (element.price +
              element.radiopricesnum! +
              element.Radiopricesnum!.toInt()) *
          element.quantity;
    }

    return total;
  }

  ////////////

  ////刪除購物車商品////
  int? deleteindex;
  void GetupdateDeleteIndex(int index) {
    deleteindex = index;
  }

  get updateDeleteIndex {
    return deleteindex;
  }

  void delete(int index) {
    cartlist.removeAt(index);
  }

  ////////////
  ///////清空購物車////
  void deleteAll() {
    for (var element in cartlist) {
      cartlist.remove(element);
    }
    return null;
  }

  ////////////
  ///////必選區選的傳到form5的addproduct////
  void addRadio({
    required String name,
  }) {
    radiolist.add(name);
  }

  void deleteall() {
    for (var element in radiolist) {
      radiolist.remove(element);
    }
  }

  ////餐具////
  bool tableWare({required bool tablewareBool}) {
    tableware = tablewareBool;
    return tableware;
  }
  //////

  ///////取餐時間////
  String getReservation({required String Time}) {
    reservationTime = Time;
    return reservationTime;
  }
  //////

  ////////整理包-最小的options////
  String options() {
    String option;
    List<List> oopopv = [];
    List optionsReturn = []; //最小的options
    List ordersReturn = []; //裝optionsReturn等其他東西
    var finalReturn; //裝tableware跟ordersReturn
    for (var i = 0; i < cartlist.length; i++) {
      optionsReturn = [];

      /// 把radioList的 => [{"title":"甜度","optionList":["全糖"]},{"title":"冰度","optionList":["正常"]}]
      for (var m = 0; m < cartlist[i].radiolist!.length; m++) {
        ////如果[]裡multiple是單選，轉成string
        if (cartlist[i].radioMultiple![m] == false) {
          optionsReturn.add(OptionsStr(cartlist[i].radioTitleList![m],
              cartlist[i].radiolist![m].join('')));
        } else if (cartlist[i].radioMultiple![m] == true) {
          optionsReturn.add(Options(
              cartlist[i].radioTitleList![m], cartlist[i].radiolist![m]));
        }
      }
      //////
      /// 換Radiolist的 =>
      for (var n = 0; n < cartlist[i].Radiolist!.length; n++) {
        ////如果[]裡multiple是單選，轉成string
        if (cartlist[i].RadioMultiple![n] == false) {
          optionsReturn.add(OptionsStr(cartlist[i].RadioTitleList![n],
              cartlist[i].Radiolist![n].join('')));
        } else if (cartlist[i].RadioMultiple![n] == true) {
          optionsReturn.add(Options(
              cartlist[i].RadioTitleList![n], cartlist[i].Radiolist![n]));
        }
      }
      //// 把(選填)有空的[ ]的optionList 跟 title 都刪掉
      optionsReturn.removeWhere((element) => element.option!.isEmpty);

      ///optionsReturn Encode成String
      option = jsonEncode(optionsReturn);
      print('option ggg $option');
      //////
      //////ordersReturn
      ordersReturn.add(Order(
          cartlist[i].id, cartlist[i].quantity, cartlist[i].text, option));

      //////
    }



    ///finalReturn
    finalReturn = Orders(tableware, reservationTime, ordersReturn);
    //////
    ///optionsReturn Encode成String
    String finalString = jsonEncode(finalReturn);
    print('finalString ggg $finalString');
    //////
    return finalString;
  }
}
