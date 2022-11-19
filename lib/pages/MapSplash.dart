import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/StoreModel.dart';
import 'package:flutterdemo02/provider/googleMapKey.dart';
import '../GoogleMap/map_services.dart';
import '../provider/Shared_Preference.dart';

class MapSplash extends StatefulWidget {
  MapSplash({Key? key, required this.arguments}) : super(key: key);
  Map arguments;
  @override
  State<MapSplash> createState() => _MapSplashState(arguments: arguments);
}

class _MapSplashState extends State<MapSplash> {
  _MapSplashState({required this.arguments});
  Map arguments;
  @override
  List<Result?>? originbooks = [];
  void addPosition(double lat, double lng, int i, String placeID) {
    originbooks![i]!.lat = lat;
    originbooks![i]!.lng = lng;
    originbooks![i]!.placeID = placeID;
  }

  Future convertToPlaceID(String address) async {
    var googleGeocoding = GoogleGeocoding(GoogleMapKey);
    var response = await googleGeocoding.geocoding.get(address, []);
    var placeID = response!.results![0].placeId;
    return placeID;
  }

  Future init() async {
    //

    originbooks =
        await MapServices.searchPlaces('', UserSimplePreferences.getToken());

    if (originbooks == null) {
      String? refresh_token = UserSimplePreferences.getRefreshToken();
      var getToken = await getTokenApi.getToken(refresh_token);
      await UserSimplePreferences.setToken(getToken.headers['token']!);
      originbooks =
          await MapServices.searchPlaces('', UserSimplePreferences.getToken());
    }


    for (var i = 0; i < originbooks!.length; i++) {
      //if ( originbooks![i]!.placeID && Lat && Lng ) UsersimplePreference is null || ( originbooks![i]!.address != UersimplePreference )? run
      //就是硬體沒有(新店家) 或 店家更換地址(ADDRESS 跟 硬碟的不一樣) 才跑
      var placeID = await convertToPlaceID(originbooks![i]!.address!);
      var place = await MapServices.getPlace(originbooks![i]!.address!);

      addPosition(
        place!['candidates'][0]['geometry']['location']['lat'],
        place['candidates'][0]['geometry']['location']['lng'],
        i,
        placeID,
      );
    }

    return originbooks;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    init().then((value) {
      if (value != null) {
        print('object is ${arguments['initialpage']}');
        Navigator.pushReplacementNamed(
        context,
        '/googlemap',
        arguments: {
          'currentLocation': arguments['currentLocation'],
          'originbooks': originbooks,
          'initialid':arguments['initialid'],
        },
      );
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200.0,
          width: 200.0,
          child: LottieBuilder.asset('assets/animassets/mapanimation.json'),
        ),
      ),
    );
  }
}
