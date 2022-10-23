import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:flutterdemo02/API/getTokenApi.dart';
import '../API/StoreModel.dart';
import '../GoogleMap/googleMapKey.dart';
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

    // //////
    // originbooks!.add(Result(
    //   name: '帥哥海底撈',
    //   address: '中壢區協同街53號',
    //   place: '女宿',
    // ));
    // originbooks!.add(Result(
    //   name: '馬辣',
    //   address: '中壢區協同街25號',
    //   place: '女宿',
    // ));
    // originbooks!.add(Result(
    //   name: '帥哥海底撈',
    //   address: '中壢區新中北路291號',
    //   place: '女宿',
    // ));
    // ///////

    for (var i = 0; i < originbooks!.length; i++) {
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
