import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutterdemo02/GoogleMap/directions_Model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DirectionRepository {
  Future<Directions?> getDirections({
    required LocationData origin,
    required LatLng destination,
  }) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyAMbmNNct9nSHK4WRT8CDempAeDJmtbLVE ';
  
    final response = await http.get(Uri.parse(url));

    print('response.statusCode is ${response.statusCode}');
    print('response.data is ${response.body}');
    if (response.statusCode == 200) {
      return Directions?.fromMap(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
