import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';

import '../API/StoreModel.dart';
import 'googleMapKey.dart';

class MapServices {
  static Future<List<Result?>?> searchPlaces(String query, token) async {
    final response = await http.get(
        Uri.parse(
            'https://hello-cycu-delivery-service.herokuapp.com/member/store'),
        headers: {
          "token": token,
          "Content-Type": "application/x-www-form-urlencoded"
        });

    if (response.statusCode == 200) {
      var obj = Store.fromJson(jsonDecode(response.body));
      var myaddress = (obj.result as List<Result?>);
      return myaddress.map((json) => json).where((element) {
        //name
        final titleLower = element!.name.toString().toLowerCase();
        //address
        final addressLower = element.address.toString().toLowerCase();
        //description
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            addressLower.contains(searchLower);
      }).toList();
    } else if (response.statusCode == 403) {
      print('statusCode in MapsearchPlaces is${response.statusCode}');
      return null;
    } else {
      throw Exception('Failed to load store');
    }
  }

  static Future<Map<String, dynamic>?>? getPlace(String? input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=geometry&input=$input&inputtype=textquery&key=$GoogleMapKey';

    var response = await http.get(Uri.parse(url));
    debugPrint('response statuscode in MapgetPlace is ${response.statusCode}');

    var json = jsonDecode(response.body);
    print('json is$json');

    return json;
  }

  static Future<Map<String, dynamic>?>? getDirections(
      LocationData? origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin!.latitude},${origin.longitude}&destination=place_id:$destination&mode=walking&key=$GoogleMapKey';

    var response = await http.get(Uri.parse(url));

    var json = jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decode': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
      'distance':json['routes'][0]['legs'][0]['distance']['text'],
      'duration':json['routes'][0]['legs'][0]['duration']['text'],
    };

    print('response statuscode in getDirectionsApi is ${response.statusCode}');

    return results;
  }
}
