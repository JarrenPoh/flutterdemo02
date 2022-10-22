import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterdemo02/GoogleMap/googleMapKey.dart';
import 'package:flutterdemo02/GoogleMap/map_services.dart';
import 'package:flutterdemo02/components5/textField.dart';
import 'package:flutterdemo02/controllers/cart_controller.dart';
import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/provider/Shared_Preference.dart';
import 'package:flutterdemo02/provider/search_places_inGoogleMap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import 'package:location/location.dart';
import '../API/StoreModel.dart';

import 'package:flip_card/flip_card.dart';
import '../models/BetweenSM.dart';
import '../models/MiddleText.dart';

//search 要按兩下toggle才等於false
//照片的東西

class googleMap extends ConsumerStatefulWidget {
  googleMap({Key? key, required this.arguments}) : super(key: key);
  Map arguments;
  @override
  _googleMapState createState() => _googleMapState(arguments: arguments);
}

class _googleMapState extends ConsumerState<googleMap> {
  _googleMapState({required this.arguments});

  Completer<GoogleMapController> _controller = Completer();

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  final cartController = Get.put(CartController());

////Debounce to throttle async calls during search
  Timer? _debounce;

////Toggling UI as we need
  bool searchToggle = false;
  bool radiusSlider = false;
  bool pageList = true;
  bool cardTapped = false;
  bool getDirections = false;
  bool finishDirections = false;

////Markers set
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  var radiusValue = 100.0;

////Circle Set
  Set<Circle> _circles = Set<Circle>();

////Page controller for nice pageview
  late PageController _pageController;

  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  final key = GoogleMapKey;
  var selectedPlaceDetail;
  bool showBlankCard = false;
  bool isReviews = true;
  bool isPhotos = false;

////Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  // TextEditingController _destinationController = TextEditingController();

  int markerIdCounter = 1;
  int polylineIdCounter = 1;

////Marker when inistate

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

  Future<void> iniMarker() async {
    for (var i = 0; i < originbooks!.length; i++) {
          final Uint8List markerIcon = await getBytesFromAsset('images/marker2.png', 120);
      var counter = markerIdCounter++;
      final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: LatLng(originbooks![i]!.lat!, originbooks![i]!.lng!),
        onTap: () async {
          _polylines = {};
          _pageController.jumpToPage(
            i,
          );
          debugPrint('處夢到的是數字 $i 和 ${originbooks![i]!.name!}');
        },
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );
      _markers.add(marker);
    }

    setState(() {});
  }

////Set Marker when Tapped Something
  void _setMarker(LatLng point) async {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
      markerId: MarkerId('marker_$counter'),
      position: point,
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers = {};
    await iniMarker();
    setState(() {
      _markers.removeWhere((element) =>
          element.position.latitude == point.latitude &&
          element.position.longitude == point.longitude);
      _markers.add(marker);
    });
  }

////Set Polyline when get Directions
  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter++;

    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Color.fromARGB(255, 0, 140, 255),
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      ),
    );
  }

  LocationData? currentLocation;
  List<Result?>? originbooks = [];
  int? initialpage = 0;

  final _focusNode = FocusNode();
  int prevPage = 0;
  @override
  void initState() {
    originbooks = arguments['originbooks'];
    currentLocation = arguments['currentLocation'];

    if (arguments['initialid'] != null) {
      var initialid = arguments['initialid'];
      initialpage =
          originbooks!.indexWhere((element) => element!.id == initialid);
    }

    fetchImage();
    _pageController =
        PageController(initialPage: initialpage!, viewportFraction: 0.85);
    iniMarker();

    if (arguments['initialid'] != null) {
      goToTappedPlace();
    }

    _pageController.addListener(() {
      if (_pageController.page!.toInt() != prevPage) {
        _polylines = {};
        prevPage = _pageController.page!.toInt();
        cardTapped = false;
        photoGalleryIndex = 0;
        showBlankCard = false;
        goToTappedPlace();
        fetchImage();
      }
    });
    // TODO: implement initState
    super.initState();
  }

////Fetch image to place inside the tile in the pageView
  void fetchImage() {
    if (originbooks![prevPage]!.image != null) {
      setState(() {
        placeImg = originbooks![prevPage]!.image!;
      });
    } else {
      setState(() {
        placeImg = '';
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _pageController.dispose();
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
                    // onTap: (point) => _setCircle(point),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                searchToggle
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(
                            Dimensions.width15,
                            Dimensions.height20*2,
                            Dimensions.width15,
                            Dimensions.height5),
                        child: Column(
                          children: [
                            Container(
                              height: Dimensions.height50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius10),
                                  color: Colors.white),
                              child: TextFormField(
                                focusNode: _focusNode,
                                autofocus: true,
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20,
                                    vertical: Dimensions.height15,
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
                                        if (!searchflag.searchToggle!) {
                                          searchflag.toggleSearch(false);
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
                searchflag.searchToggle == true
                    ? allSearchResults.allReturnResults!.length != 0
                        ? Positioned(
                            top: Dimensions.height50 * 2,
                            left: Dimensions.width15,
                            child: Stack(
                              children: [
                                if (searchToggle == true)
                                  Container(
                                    height: Dimensions.height50 * 4,
                                    width: screenWidth - Dimensions.width15 * 2,
                                    child: Icon(
                                      Icons.search,
                                      color: kMaim3Color.withOpacity(0.35),
                                      size: Dimensions.icon25 * 7,
                                    ),
                                  ),
                                if (getDirections == true)
                                  Container(
                                    height: Dimensions.height50 * 4,
                                    width: screenWidth - Dimensions.width15 * 2,
                                    child: Icon(
                                      Icons.navigation,
                                      color: kMaim3Color.withOpacity(0.35),
                                      size: Dimensions.icon25 * 7,
                                    ),
                                  ),
                                Container(
                                  height: Dimensions.height50 * 4,
                                  width: screenWidth - Dimensions.width15 * 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius10),
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  child: ListView(
                                    children: List.generate(
                                        originbooks!.length,
                                        (index) =>
                                            buildListItem(index, searchflag))
                                    // ...allSearchResults.allReturnResults!.map(
                                    //     (e) => buildListItem(e, searchflag))
                                    ,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Positioned(
                            top: Dimensions.height50 * 2,
                            left: Dimensions.width15,
                            child: Container(
                              width: screenWidth - Dimensions.width15 * 2,
                              height: Dimensions.height50 * 4,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius10),
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
                                      width: Dimensions.width10 / 2,
                                    ),
                                    Container(
                                      width: Dimensions.width20 * 6 +
                                          Dimensions.width10 / 2,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          searchflag.toggleSearch(false);
                                          searchToggle = false;
                                          getDirections = false;
                                          finishDirections = false;
                                          // searchBook(searchController.text,
                                          //   allSearchResults);
                                          print(
                                              'searchflag.searchToggle is ${searchflag.searchToggle}');
                                          searchController.text = '';
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
                // finishDirections
                //     ? Positioned(
                //         top: 150,
                //         width: Dimensions.screenWidth
                //         ,
                //         child: Padding(
                //           padding:  EdgeInsets.fromLTRB(Dimensions.width20*6,Dimensions.height5,Dimensions.width20*6,Dimensions.height5),
                //           child: Container(
                //             height: Dimensions.height50,
                //             decoration: BoxDecoration(
                //               borderRadius:
                //                   BorderRadius.circular(Dimensions.radius10),
                //               color: Colors.red.shade100,
                //             ),
                //           ),
                //         ),
                //       )
                //     : Container(),
                getDirections
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(
                            Dimensions.width15,
                            Dimensions.height20 * 2,
                            Dimensions.width15,
                            Dimensions.height5),
                        child: Column(
                          children: [
                            Container(
                              height: Dimensions.height50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius10),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                focusNode: _focusNode,
                                autofocus: true,
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width20,
                                    vertical: Dimensions.height15,
                                  ),
                                  border: InputBorder.none,
                                  hintText: '路線',
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        getDirections = false;
                                        finishDirections = false;
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
                                        if (!searchflag.searchToggle!) {
                                          searchflag.toggleSearch(false);
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
                pageList == true
                    ? Positioned(
                        bottom: 0.0,
                        child: Container(
                          height: Dimensions.height50 * 5,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: originbooks!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _placesList(
                                  originbooks, index, searchflag);
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
        key: fabKey,
        alignment: Alignment.bottomLeft,
        fabColor: Colors.red.shade100,
        fabOpenColor: Colors.blue.shade50,
        ringDiameter: 250.0,
        ringWidth: 60.0,
        ringColor: Colors.red.shade100,
        fabSize: 60.0,
        animationDuration: Duration(milliseconds: 400),
        children: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  searchToggle = true;
                  getDirections = false;
                  finishDirections = false;
                  if (allSearchResults.allReturnResults!.isEmpty) {
                    allSearchResults.allReturnResults = originbooks;
                  }
                  radiusSlider = false;
                  pageList = true;
                  cardTapped = false;

                  _focusNode.addListener(() {
                    searchflag.toggleSearch(true);
                    pageList = true;
                  });
                  fabKey.currentState?.close();
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
                  getDirections = true;
                  finishDirections = false;
                  if (allSearchResults.allReturnResults!.isEmpty) {
                    allSearchResults.allReturnResults = originbooks;
                  }
                  radiusSlider = false;
                  pageList = true;
                  cardTapped = false;

                  _focusNode.addListener(() {
                    searchflag.toggleSearch(true);
                  });
                  fabKey.currentState?.close();
                },
              );
            },
            icon: Icon(Icons.navigation),
          ),
          IconButton(onPressed: _currentLocation, icon: Icon(Icons.my_location_outlined),)
        ],
      ),
    );
  }

  _buildReviewItem(int index) {
    List businessTime = originbooks![index]!.businessTime!;
    List startTime = [];
    List endTime = [];

    for (var i = 0; i < businessTime.length; i++) {
      if (i == 0 && businessTime[i] == true) {
        startTime.add(0);
      } else if (businessTime[i] == true &&
          businessTime[i - 1] == false &&
          businessTime[i + 1] == false) {
        //只營業1小時
        startTime.add(i);
        endTime.add(i);
      } else if (businessTime[i] == true && businessTime[i - 1] == false) {
        startTime.add(i);
      } else if (i == 23 && businessTime[i] == true) {
        endTime.add(23);
      } else if (businessTime[i] == true && businessTime[i + 1] == false) {
        endTime.add(i);
      }
    }
    debugPrint('${originbooks![index]!.name!}startTime is $startTime');
    debugPrint('endTime is $endTime');
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Dimensions.width10,
            right: Dimensions.width10,
            top: Dimensions.height10,
          ),
          child: Row(
            children: [
              if (originbooks![1]!.image != null)
                Container(
                  width: Dimensions.width20 + Dimensions.width15,
                  height: Dimensions.height20 + Dimensions.height15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(originbooks![1]!.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (originbooks![index] != null)
                Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.width20 * 2,
                      right: Dimensions.width20 * 2,
                      bottom: Dimensions.height5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.width20),
                        child: MiddleText(
                          color: kBodyTextColor,
                          text: '${originbooks![index]!.name}',
                          fontFamily: 'NotoSansMedium',
                        ),
                      ),
                      SizedBox(height: 10),
                      if (originbooks![index]!.address != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabText(
                                color: kTextLightColor,
                                text: '地址:',
                                fontFamily: 'NotoSansMedium',
                              ),
                              Container(
                                width: Dimensions.width10 * 21,
                                child: TabText(
                                  color: kBodyTextColor,
                                  text: '${originbooks![index]!.address}',
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: 1,
                          width: Dimensions.width10 * 21,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabText(
                              color: kTextLightColor,
                              text: originbooks![index]!.place != null
                                  ? '類別'
                                  : '未分類',
                              fontFamily: 'NotoSansMedium',
                            ),
                            TabText(
                              color: kBodyTextColor,
                              text: '${originbooks![index]!.place}',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: 1,
                          width: Dimensions.width10 * 21,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabText(
                              color: kTextLightColor,
                              text: '折扣',
                              fontFamily: 'NotoSansMedium',
                            ),
                            TabText(
                              color: kBodyTextColor,
                              text: jsonDecode(originbooks![index]!.discount!)
                                      .isNotEmpty
                                  ? '消費: 滿 ${jsonDecode(originbooks![index]!.discount!)[0]['goal']} 送 ${jsonDecode(originbooks![index]!.discount!)[0]['discount']} 元'
                                  : '目前無折扣',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: 1,
                          width: Dimensions.width10 * 21,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TabText(
                              color: kTextLightColor,
                              text: '備餐預估',
                              fontFamily: 'NotoSansMedium',
                            ),
                            TabText(
                              color: kBodyTextColor,
                              text: originbooks![index]!.timeEstimate != null
                                  ? '${originbooks![index]!.timeEstimate} 分鐘'
                                  : '無預估',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: 1,
                          width: Dimensions.width10 * 21,
                        ),
                      ),
                      if (originbooks![index]!.businessTime != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabText(
                                color: kTextLightColor,
                                text: '今天營業時間:',
                                fontFamily: 'NotoSansMedium',
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  startTime.length,
                                  (index) {
                                    String startText = '';
                                    if (startTime[index] == 0) {
                                      startText = '00:00';
                                    } else if (startTime[index] != 0) {
                                      if (startTime[index] > 12) {
                                        startText =
                                            '${startTime[index] - 12}:00';
                                      } else {
                                        startText = '${startTime[index]}:00';
                                      }
                                    }
                                    String endText = '';
                                    if (endTime[index] == 23) {
                                      endText = '00:00';
                                    } else if (endTime[index] != 0) {
                                      if (endTime[index] + 1 > 12) {
                                        endText =
                                            '${endTime[index] + 1 - 12}:00';
                                      } else {
                                        endText = '${endTime[index] + 1}:00';
                                      }
                                    }
                                    String startNoon = '';
                                    String endNoon = '';
                                    if (startTime[index] < 12) {
                                      startNoon = '上午';
                                    } else {
                                      startNoon = '下午';
                                    }
                                    if (endTime[index] + 1 < 12 ||
                                        endTime[index] + 1 == 24) {
                                      endNoon = '上午';
                                    } else {
                                      endNoon = '下午';
                                    }
                                    return Column(
                                      children: [
                                        TabText(
                                          color: kBodyTextColor,
                                          text:
                                              '$startNoon $startText ~ $endNoon $endText',
                                          fontFamily: 'NotoSansMedium',
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: 1,
                          width: Dimensions.width10 * 21,
                        ),
                      ),
                      if (originbooks![index]!.describe != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabText(
                                color: kTextLightColor,
                                text: '介紹:',
                                fontFamily: 'NotoSansMedium',
                              ),
                              Container(
                                width: Dimensions.width10 * 21,
                                child: TabText(
                                  color: kBodyTextColor,
                                  text: '${originbooks![index]!.describe}',
                                  maxLines: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Divider()
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  _buildPhotoGallery() {
    // if (originbooks![0]!.image == null || originbooks![0]!.image!.length == 0) {
    if (originbooks!.length == 0) {
      showBlankCard = true;
      return Container(
        child: Center(
          child: TabText(color: kBodyTextColor, text: 'No Photos'),
        ),
      );
    } else {
      var placeImg = originbooks![photoGalleryIndex]!.image;
      var tempDisplayIndex = photoGalleryIndex + 1;
      return Column(
        children: [
          SizedBox(height: Dimensions.height10),
          if (placeImg != null)
            Container(
              height: Dimensions.height50 * 4,
              width: Dimensions.width20 * 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                image: DecorationImage(
                  image: NetworkImage(placeImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (placeImg == null)
            Container(
              height: Dimensions.height50 * 2,
              width: Dimensions.width20 * 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                color: Colors.grey,
              ),
            ),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (photoGalleryIndex != 0)
                      photoGalleryIndex = photoGalleryIndex - 1;
                    else
                      photoGalleryIndex = 0;
                  });
                },
                child: Container(
                  width: Dimensions.width20 / 10 * 22,
                  height: Dimensions.height20 / 10 * 11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    color: photoGalleryIndex != 0
                        ? kMaim3Color
                        : Colors.grey.shade500,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.west_outlined,
                      color: Colors.white,
                      size: Dimensions.icon25 / 25 * 17,
                    ),
                  ),
                ),
              ),
              TabText(
                color: kBodyTextColor,
                text: '$tempDisplayIndex/ ' + originbooks!.length.toString(),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (photoGalleryIndex != originbooks!.length - 1)
                      photoGalleryIndex = photoGalleryIndex + 1;
                    else
                      photoGalleryIndex = originbooks!.length - 1;
                  });
                },
                child: Container(
                  width: Dimensions.width20 / 10 * 22,
                  height: Dimensions.height20 / 10 * 11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != originbooks!.length - 1
                        ? kMaim3Color
                        : Colors.grey.shade500,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.east_outlined,
                      color: Colors.white,
                      size: Dimensions.icon25 / 25 * 17,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }
  }

  gotoPlace(int lindex, double lat, double lng, double endLat, double endLng,
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

    _setMarker(LatLng(originbooks![lindex]!.lat!, originbooks![lindex]!.lng!));
  }

  _placesList(List<Result?>? placeItem, index, SearchToggle searchFlag) {
    bool businessTime;
    int selectedHour = TimeOfDay.now().hour;
    if (placeItem![index]!.businessTime![selectedHour] == true) {
      print('營業中');
      businessTime = true;
    } else {
      print('尚未營業');
      businessTime = false;
    }
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
            height:
                Curves.easeInOut.transform(value) * Dimensions.height50 * 6 + 3,
            width: Curves.easeOut.transform(value) * Dimensions.width15 * 25,
            child: widget,
          ),
        );
      },
      child: FlipCard(
        front: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height20,
                ),
                height: Dimensions.height20 * 10,
                width: Dimensions.width10 * 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, Dimensions.height5 / 5 * 4),
                      blurRadius: Dimensions.radius10,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child: Column(
                    children: [
                      _pageController.position.haveDimensions
                          ? _pageController.page!.toInt() == index ||
                                  _pageController.page!.toInt() == index + 1 ||
                                  _pageController.page!.toInt() == index - 1
                              ? placeImg != ''
                                  ? Container(
                                      height: Dimensions.height10 * 13,
                                      width: Dimensions.width10 * 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Dimensions.radius10),
                                          topRight: Radius.circular(
                                              Dimensions.radius10),
                                        ),
                                      ),
                                      child: Image.network(placeImg),
                                    )
                                  : Container(
                                      height: Dimensions.height10 * 13,
                                      width: Dimensions.width10 * 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Dimensions.radius10),
                                          topRight: Radius.circular(
                                              Dimensions.radius10),
                                        ),
                                        color: Colors.grey,
                                      ),
                                    )
                              : Container(
                                  height: Dimensions.height10 * 13,
                                  width: Dimensions.width20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(Dimensions.radius10),
                                      topLeft:
                                          Radius.circular(Dimensions.radius10),
                                    ),
                                    color: Colors.white,
                                  ),
                                )
                          : Container(),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: Dimensions.width10 * 26,
                            child: TabText(
                              color: kBodyTextColor,
                              text: '   ${placeItem[index]!.name!}',
                              fontFamily: 'NotoSansMedium',
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            width: Dimensions.width10 * 26,
                            child: TabText(
                              color: kTextLightColor,
                              text: '   ${placeItem[index]!.address!}',
                              fontFamily: 'NotoSansMedium',
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            width: Dimensions.width10 * 26,
                            child: TabText(
                              color: businessTime ? Colors.green : Colors.red,
                              text: businessTime ? '   營業中' : '   休息中',
                              fontFamily: 'NotoSansMedium',
                              maxLines: 1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (cartController.cartlist.isNotEmpty &&
                          cartController.cartlist.first.shopname !=
                              originbooks![index]?.name) {
                        bool? delete = await showDeleteDialod();
                        if (delete == false) {
                          Navigator.pushNamed(
                            context,
                            '/form4',
                            arguments: {
                              'shopname': originbooks![index]?.name,
                              'shopimage': originbooks![index]?.image,
                              'discount':
                                  jsonDecode(originbooks![index]!.discount!),
                              'id': originbooks![index]?.id,
                              'businessTime': originbooks![index]?.businessTime,
                              'timeEstimate': originbooks![index]?.timeEstimate,
                              'describe': originbooks![index]?.describe,
                            },
                          );
                          cartController.deleteAll();
                        }
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/form4',
                          arguments: {
                            'shopname': originbooks![index]?.name,
                            'shopimage': originbooks![index]?.image,
                            'discount':
                                jsonDecode(originbooks![index]!.discount!),
                            'id': originbooks![index]?.id,
                            'businessTime': originbooks![index]?.businessTime,
                            'timeEstimate': originbooks![index]?.timeEstimate,
                            'describe': originbooks![index]?.describe,
                          },
                        );
                      }
                    },
                    child: Icon(
                      Icons.store_outlined,
                      size: Dimensions.icon25,
                      color: kMaim3Color,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(10, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3000.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      var directions = await MapServices.getDirections(
                        currentLocation,
                        originbooks![index!]!.placeID!,
                      );
                      finishDirections = true;
                      _polylines = {};
                      await gotoPlace(
                        index,
                        directions!['start_location']['lat'],
                        directions['start_location']['lng'],
                        directions['end_location']['lat'],
                        directions['end_location']['lng'],
                        directions['bounds_ne'],
                        directions['bounds_sw'],
                      );
                      _setPolyline(directions['polyline_decode']);
                      searchFlag.toggleSearch(false);
                    },
                    child: Icon(
                      Icons.directions_walk_outlined,
                      size: Dimensions.icon25,
                      color: kMaim3Color,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(10, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3000.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        back: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.width10,
              vertical: Dimensions.height20,
            ),
            height: Dimensions.height20 * 10,
            width: Dimensions.width10 * 35,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius:
                    BorderRadius.circular(Dimensions.radius10 / 10 * 8)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.radius10 / 10 * 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isReviews = true;
                              isPhotos = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeIn,
                            padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius10),
                              color: isReviews ? kMaim3Color : Colors.white,
                            ),
                            child: Container(
                              width: Dimensions.width10 * 5,
                              child: Center(
                                child: SmallText(
                                  color:
                                      isReviews ? Colors.white : Colors.black87,
                                  text: '簡述',
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isReviews = false;
                              isPhotos = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeIn,
                            padding: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius10),
                              color: isPhotos ? kMaim3Color : Colors.white,
                            ),
                            child: Container(
                              width: Dimensions.width10 * 5,
                              child: Center(
                                child: SmallText(
                                  color:
                                      isPhotos ? Colors.white : Colors.black87,
                                  text: '照片',
                                  fontFamily: 'NotoSansMedium',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: isReviews
                        ? _buildReviewItem(index)
                        : _buildPhotoGallery(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller = await _controller.future;

    var selectPlace = originbooks![_pageController.page!.toInt()];

    _setMarker(LatLng(selectPlace!.lat!, selectPlace.lng!));

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(selectPlace.lat!, selectPlace.lng!),
          zoom: 16.0,
        ),
      ),
    );
  }

  Future<void> gotoSearchPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat + 0.00125, lng),
          zoom: 17,
        ),
      ),
    );

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(int? lindex, SearchToggle searchFlag) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 8.0),
      child: GestureDetector(
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          //
          if (searchToggle == true) {
            _polylines = {};
            searchFlag.toggleSearch(false);
            _pageController.jumpToPage(
              lindex!,
            );
          } else if (getDirections == true) {
            FocusManager.instance.primaryFocus?.unfocus();
            var directions = await MapServices.getDirections(
              currentLocation,
              originbooks![lindex!]!.placeID!,
            );
            finishDirections = true;
            _polylines = {};
            await gotoPlace(
              lindex,
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
            Icon(Icons.location_on,
                color: kMaim3Color, size: Dimensions.icon25),
            SizedBox(width: Dimensions.width10 / 2),
            Container(
              width: MediaQuery.of(context).size.width - Dimensions.width15 * 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${originbooks![lindex!]!.name!}   -${originbooks![lindex]!.address!}'),
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

  void _currentLocation() async {
    FocusManager.instance.primaryFocus?.unfocus();
    fabKey.currentState?.close();
   final GoogleMapController controller = await _controller.future;
   LocationData? currentLocation;
   var location =  Location();
   try {
     currentLocation = await location.getLocation();
     } on Exception {
       currentLocation = null;
       }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
    
  }

}
