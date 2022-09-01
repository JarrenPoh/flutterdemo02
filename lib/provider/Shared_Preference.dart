import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keyRefreshToken = 'refreshToken';
  static const _keyGoogleKey = 'googlekey';
  static const _keyToken = 'token';
  static const _keyUserEmail = 'useremail';
  static const _keyUserName = 'username';
  static const _keyUserPicture = 'userpicture';
  static const _keyUserDate = 'userdate';
  static const _keyUserPhone = 'userphone';
  static const _finalPrice = 'finalprice';
  static const _orderPreview = 'orederpreview';
  static const _phoneverify = 'phoneverify';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //////////////////////
  static Future clearPreference() async {
    await _preferences!.clear();
    print('刪除記憶存取');
    print('UserSimplePreferences._keyGoogleKey is ${GetGoogleKey()}');
  }
  /////////////////////

  ///////////Refresh Token///////////////
  static Future setRefreshToken(String refreshToken) async {
    await _preferences?.setString(_keyRefreshToken, refreshToken);
    // _preferences!.clear();
  }

  static String? getRefreshToken() => _preferences?.getString(_keyRefreshToken);
  ///////////////////////////////////////
  //////////////Google Key///////////////
  static Future setGoogleKey(String googleKey) async {
    await _preferences?.setString(_keyGoogleKey, googleKey);
    // _preferences!.clear();
  }

  static String? GetGoogleKey() => _preferences?.getString(_keyGoogleKey);
  ///////////////////////////////////////
  ///////////////Token//////////////////
  static Future setToken(String token) async {
    await _preferences?.setString(_keyToken, token);

    // _preferences!.clear();
  }

  static String? getToken() => _preferences?.getString(_keyToken);
  //////////////////////////////////////
  ///////////////UserInformation////////
  static Future setUserInformation(
    String userEmail,
    String userName,
    String userPicture,
  ) async {
    await _preferences?.setString(_keyUserEmail, userEmail);
    await _preferences?.setString(_keyUserName, userName);
    await _preferences?.setString(_keyUserPicture, userPicture);
  }

  static String? getUserEmail() => _preferences?.getString(_keyUserEmail);
  static String? getUserName() => _preferences?.getString(_keyUserName);
  static String? getUserPicture() => _preferences?.getString(_keyUserPicture);
  //////////////////////////////////////
  //////////////////UserBirthday////////
  static Future setUserBirthday(String birthday) async {
    await _preferences?.setString(_keyUserDate, birthday);
  }

  static String? getUserBirthday() => _preferences?.getString(_keyUserDate);
  //////////////////////////////////////
  /////////////////////UserPhone////////
  static Future setUserPhone(String phone) async {
    await _preferences?.setString(_keyUserPhone, phone);
  }

  static String? getUserPhone() => _preferences?.getString(_keyUserPhone);
  //////////////////////////////////////
  ////////////////////////FinalPrice/////
  static Future setFinalPrice(int finalprice) async {
    await _preferences?.setInt(_finalPrice, finalprice);
    print('Set Preference successful');
  }

  static int? getFinalPrice() => _preferences!.getInt(_finalPrice);
  //////////////////////////////////////
  ///////////////////////////OrderPreiew/////
  static Future setOrderPreview(String prderpreview) async {
    await _preferences?.setString(_orderPreview, prderpreview);
    print('Set Preference successful');
  }

  static String? getOrderPreview() => _preferences!.getString(_orderPreview);
  //////////////////////////////////////
  ///////////////////////////PhoneVerify/////
  static Future setPhoneVerify(bool phoneverify) async {
    await _preferences?.setBool(_phoneverify, phoneverify);
    print('Set Preference successful');
  }

  static bool? getPhoneVerify() => _preferences!.getBool(_phoneverify);
  //////////////////////////////////////
}
