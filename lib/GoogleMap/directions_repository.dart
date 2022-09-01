import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterdemo02/GoogleMap/directions_Model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_directions_api/google_directions_api.dart';

class DirectionRepository {
  Future<Directions?> getDirections({
    required LocationData origin,
    required LatLng destination,
  }) async {
    String _bareUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyAMbmNNct9nSHK4WRT8CDempAeDJmtbLVE ';
  
    final response = await Dio().get(
      _bareUrl,
    );

    print('response.statusCode is ${response.statusCode}');
    print('response.data is ${response.data}');
    if (response.statusCode == 200) {
      return Directions?.fromMap(response.data);
    } else {
      return null;
    }
  }
}
