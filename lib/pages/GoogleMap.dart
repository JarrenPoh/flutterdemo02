import 'dart:async';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdemo02/GoogleMap/googleMapKey.dart';
import 'package:flutterdemo02/GoogleMap/map_services.dart';
import 'package:flutterdemo02/components5/textField.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/provider/search_places_inGoogleMap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:location/location.dart';
import '../API/StoreModel.dart';
import 'package:google_geocoding/google_geocoding.dart';
//
//剛進去個個店家就出來
//搜尋看到店家資料
//點了去到form4
//路線隨時setstate位置

class googleMap extends ConsumerStatefulWidget {
  googleMap({Key? key, required this.arguments}) : super(key: key);
  Map arguments;
  @override
  _googleMapState createState() => _googleMapState(arguments: arguments);
}

class _googleMapState extends ConsumerState<googleMap> {
  _googleMapState({required this.arguments});

  Completer<GoogleMapController> _controller = Completer();

////Debounce to throttle async calls during search
  Timer? _debounce;

////Toggling UI as we need
  bool searchToggle = false;
  bool radiusSlider = false;
  bool pageList = true;
  bool cardTapped = false;
  bool getDirections = false;

////Markers set
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  var radiusValue = 100.0;

////Circle Set
  Set<Circle> _circles = Set<Circle>();

////Page controller for nice pageview
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  final key = GoogleMapKey;
  var selectedPlaceDetail;
  bool showBlankCard = false;

////Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  // TextEditingController _destinationController = TextEditingController();

  int markerIdCounter = 1;
  int polylineIdCounter = 1;

////Marker when inistate
  void iniMarker() async {
    originbooks = await arguments['originbooks'];

    for (var i = 0; i < originbooks!.length; i++) {
      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration.empty, "images/location.png");
      var counter = markerIdCounter++;
      final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: LatLng(originbooks![i]!.lat!, originbooks![i]!.lng!),
        onTap: () {},
        icon: icon,
      );
      _markers.add(marker);
    }

    setState(() {});
  }

  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
      markerId: MarkerId('marker_$counter'),
      position: point,
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      ),
    );
  }

  Future convertToPlaceID(String address) async {
    var googleGeocoding = GoogleGeocoding(GoogleMapKey);
    var response = await googleGeocoding.geocoding.get(address, []);
    var placeID = response!.results![0].placeId;
    return placeID;
  }

  LocationData? currentLocation;
  List<Result?>? originbooks = [];

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: point,
          zoom: 12,
        ),
      ),
    );

    setState(() {
      _circles.add(
        Circle(
          circleId: CircleId('raj'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
      getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }

  final _focusNode = FocusNode();

  @override
  void initState() {
    currentLocation = arguments['currentLocation'];
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    iniMarker();
    // TODO: implement initState
    super.initState();
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      goToTappedPlace();
      fetchImage();
    }
  }

////Fetch image to place inside the tile in the pageView
  void fetchImage() async {
    if (_pageController.page !=
        null) if (originbooks![_pageController.page!.toInt()]!.image != null) {
      setState(() {
        placeImg = originbooks![_pageController.page!.toInt()]!.image!;
      });
    } else {
      placeImg = '';
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Map arguments;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchflag = ref.watch(searchToggleProvider);
    

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                    circles: _circles,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                      zoom: 15,
                    ),
                    onTap: (point) => _setCircle(point),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                searchToggle
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                        child: Column(
                          children: [
                            Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
                              child: TextFormField(
                                focusNode: _focusNode,
                                autofocus: true,
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 15.0,
                                  ),
                                  border: InputBorder.none,
                                  hintText: '搜尋',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searchToggle = false;
                                        searchController.text = '';
                                        searchflag.toggleSearch(false);
                                        searchBook(searchController.text,
                                            allSearchResults);
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false)
                                    _debounce?.cancel();
                                  _debounce = Timer(
                                    Duration(milliseconds: 100),
                                    () async {
                                      if (value.length >= 0) {
                                        if (!searchflag.searchToggle) {
                                          searchflag.toggleSearch(false);
                                          _markers = {};
                                        }

                                        searchBook(value, allSearchResults);
                                      } else {
                                        List<Result?> emptyList = [];
                                        allSearchResults.setResult(emptyList);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                searchflag.searchToggle
                    ? allSearchResults.allReturnResults!.length != 0
                        ? Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Stack(
                              children: [
                                if (searchToggle == true)
                                  Container(
                                    height: 200.0,
                                    width: screenWidth - 30.0,
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.red.withOpacity(0.35),
                                      size: 170.0,
                                    ),
                                  ),
                                if (getDirections == true)
                                  Container(
                                    height: 200.0,
                                    width: screenWidth - 30.0,
                                    child: Icon(
                                      Icons.navigation,
                                      color: Colors.red.withOpacity(0.35),
                                      size: 170.0,
                                    ),
                                  ),
                                Container(
                                  height: 200.0,
                                  width: screenWidth - 30.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  child: ListView(
                                    children: [
                                      ...allSearchResults.allReturnResults!.map(
                                          (e) => buildListItem(e, searchflag))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Container(
                              width: screenWidth - 30.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'No result to show',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      width: 125.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          searchflag.toggleSearch(false);
                                        },
                                        child: Center(
                                          child: Text(
                                            'Close this',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                    : Container(),
                getDirections
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
                              child: TextFormField(
                                focusNode: _focusNode,
                                autofocus: true,
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 15.0,
                                  ),
                                  border: InputBorder.none,
                                  hintText: '路線',
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        getDirections = false;
                                        searchflag.toggleSearch(false);
                                        searchBook(searchController.text,
                                            allSearchResults);
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false)
                                    _debounce?.cancel();
                                  _debounce = Timer(
                                    Duration(milliseconds: 100),
                                    () async {
                                      if (value.length >= 0) {
                                        if (!searchflag.searchToggle) {
                                          searchflag.toggleSearch(false);
                                          _markers = {};
                                        }

                                        searchBook(value, allSearchResults);
                                      } else {
                                        List<Result?> emptyList = [];
                                        allSearchResults.setResult(emptyList);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                pageList
                    ==true? Positioned(
                        bottom: 20.0,
                        child: Container(
                          
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: originbooks!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _placesList(index);
                            },
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
        alignment: Alignment.bottomLeft,
        fabColor: Colors.blue.shade50,
        fabOpenColor: Colors.red.shade100,
        ringDiameter: 250.0,
        ringWidth: 60.0,
        ringColor: Colors.blue.shade50,
        fabSize: 60.0,
        animationDuration: Duration(milliseconds: 400),
        children: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  searchToggle = true;
                  if (allSearchResults.allReturnResults!.isEmpty) {
                    allSearchResults.allReturnResults = originbooks;
                  }
                  _focusNode.addListener(() {
                    searchflag.toggleSearch(true);
                  });
                  radiusSlider = false;
                  pageList = false;
                  cardTapped = false;
                  getDirections = false;
                },
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(
                () {
                  searchToggle = false;
                  if (allSearchResults.allReturnResults!.isEmpty) {
                    allSearchResults.allReturnResults = originbooks;
                  }
                  radiusSlider = false;
                  pageList = false;
                  cardTapped = false;
                  getDirections = true;
                  _focusNode.addListener(() {
                    searchflag.toggleSearch(true);
                  });
                },
              );
            },
            icon: Icon(Icons.navigation),
          ),
        ],
      ),
    );
  }

  gotoPlace(double lat, double lng, double endLat, double endLng,
      Map<String, dynamic> bounds_ne, Map<String, dynamic> bounds_sw) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(bounds_sw['lat'], bounds_sw['lng']),
          northeast: LatLng(bounds_ne['lat'], bounds_ne['lng']),
        ),
        25,
      ),
    );

    _setMarker(LatLng(lat, lng));
    _setMarker(LatLng(endLat, endLng));
  }

  _placesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 125.0,
                width: 275.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      _pageController.position.haveDimensions
                          ? _pageController.page!.toInt() == index
                              ? placeImg != ''
                                  ? Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Image.network(placeImg),
                                    )
                                  : Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                        ),
                                        color: Colors.grey,
                                      ),
                                    )
                              : Container(
                                  height: 90.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                    ),
                                    color: Colors.blue,
                                  ),
                                )
                          : Container()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller = await _controller.future;

    _markers = {};

    var selectPlace = originbooks![_pageController.page!.toInt()];

    _setMarker(LatLng(selectPlace!.lat!, selectPlace.lng!));

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(selectPlace.lat!, selectPlace.lng!),
          zoom: 14.0,
          bearing: 45.0,
          tilt: 45.0,
        ),
      ),
    );
  }

  Future<void> gotoSearchPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15,
        ),
      ),
    );

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(Result? placeItem, SearchToggle searchFlag) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 8.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          if (searchToggle == true) {
            _markers = {};
            _polylines = {};
            gotoSearchPlace(
              placeItem!.lat!,
              placeItem.lng!,
            );
            searchFlag.toggleSearch(false);
          } else if (getDirections == true) {
            var directions = await MapServices.getDirections(
              currentLocation,
              placeItem!.placeID!,
            );
            _markers = {};
            _polylines = {};
            gotoPlace(
              directions!['start_location']['lat'],
              directions['start_location']['lng'],
              directions['end_location']['lat'],
              directions['end_location']['lng'],
              directions['bounds_ne'],
              directions['bounds_sw'],
            );
            _setPolyline(directions['polyline_decode']);
            searchFlag.toggleSearch(false);
          }
        },
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 25.0),
            SizedBox(width: 4.0),
            Container(
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('${placeItem!.name}   -${placeItem.address}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchBook(String query, PlaceResults allSearchResults) {
    List<Result?>? book = originbooks!.where((e) {
      final titleLower = e!.name.toString().toLowerCase();
      final addressLower = e.address.toString().toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          addressLower.contains(searchLower);
    }).toList();

    setState(() {
      allSearchResults.allReturnResults = book;
    });
  }
}