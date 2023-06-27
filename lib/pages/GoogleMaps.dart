import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/GoogleMap/directions_Model.dart';
import 'package:flutterdemo02/GoogleMap/directions_repository.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class GoogleMaps extends StatefulWidget {
  Map arguments;
  GoogleMaps({
    Key? key,
    required this.arguments,
  }) : super(key: key);
  @override
  State<GoogleMaps> createState() => GoogleMapsState(arguments: arguments);
}

class GoogleMapsState extends State<GoogleMaps> {
  GoogleMapsState({required this.arguments});
  Map arguments;
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng destination = LatLng(25.063695, 121.538497);
  // static const LatLng home = LatLng(25.064146, 121.528905);

  String googleAPiKey = "AIzaSyAMbmNNct9nSHK4WRT8CDempAeDJmtbLVE";

  List<LatLng> polylineCordinates = [];
  LocationData? currentLocation;

  Directions? _info;

  void getCurrentLocation() async {
    Location location = Location();

    info(currentLocation);

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        info(currentLocation);
        ////////////跟隨移動
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
////////////////////
      },
    );
  }

  void getPolyPoints(LocationData newLoc) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(newLoc.latitude!, newLoc.longitude!),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCordinates.clear();
      result.points.forEach(
        (PointLatLng point) => polylineCordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
    }
  }

  var _customerPicture;
  var myuri = Uri.parse(UserSimplePreferences.getUserPicture().toString());

  void setCustomerMarkerIcon() async {
    final http.Response customerPicture = await http.get(myuri);
    _customerPicture = BitmapDescriptor.fromBytes(customerPicture.bodyBytes);
    setState(() {});
  }

  void info(cc) async {
    final directions = await DirectionRepository().getDirections(
      origin: cc,
      destination: destination,
    );
    setState(() {
      _info = directions;
    });
  }

  @override
  void initState() {
    currentLocation = arguments['currentLocation'];
    getCurrentLocation();
    setCustomerMarkerIcon();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Order',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: Text('Loading'))
          : Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                    zoom: 13.5,
                  ),
                  polylines: {
                    if (_info != null)
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: _info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                        color: kMaim3Color,
                        width: 4,
                      ),
                  },
                  markers: {
                    Marker(
                      icon: _customerPicture,
                      markerId: const MarkerId("currenlocation"),
                      position: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                    ),
                    const Marker(
                      icon: BitmapDescriptor.defaultMarker,
                      markerId: MarkerId("destination"),
                      position: destination,
                    ),
                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                ),
                if (_info != null)
                  Positioned(
                    top: 20.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 0.6,
                          ),
                        ],
                      ),
                      child: Text(
                        '${_info!.totalDistance}, ${_info!.totalDuration}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
