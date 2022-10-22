import 'package:flutter/material.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class imageItems extends StatelessWidget {
  imageItems({
    Key? key,
    required this.name,
    required this.address,
    required this.image,
    required this.press,
    required this.discount,
    required this.timeEstimate,
    required this.businessTime,
    required this.id,
  }) : super(key: key);

  final String name;
  final String? address;
  final String? image;
  final String? timeEstimate;
  final bool businessTime;
  final VoidCallback press;
  final String id;
  List? discount = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimensions.width15, 0, Dimensions.width15, 0),
              child: Stack(
                children: [
                  if (image != null)
                    AspectRatio(
                      aspectRatio: 20 / 9,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                        child: Image.network(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (image == null)
                    AspectRatio(
                      aspectRatio: 20 / 9,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  if (discount!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.height15),
                      child: Container(
                        height: Dimensions.screenHeigt / 27.5,
                        width: Dimensions.screenWidth / 3.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius10),
                              bottomRight:
                                  Radius.circular(Dimensions.radius10)),
                          color: Colors.white,
                        ),
                        child: Container(
                          height: Dimensions.screenHeigt / 27.5,
                          width: Dimensions.screenWidth / 3.2,
                          padding: EdgeInsets.only(
                              top: Dimensions.height5,
                              bottom: Dimensions.height5,
                              left: Dimensions.height10),
                          child: SmallText(
                            color: Colors.white,
                            text:
                                '滿${discount![0]['goal']}折${discount![0]['discount']}元',
                            fontFamily: 'NotoSansMedium',
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius10),
                                bottomRight:
                                    Radius.circular(Dimensions.radius10)),
                            color: kMaim3Color,
                          ),
                        ),
                      ),
                    ),
                  if (timeEstimate != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: Dimensions.screenHeigt / 6.6,
                        left: Dimensions.screenWidth / 1.4,
                      ),
                      child: Container(
                        height: Dimensions.screenHeigt / 27.5,
                        width: Dimensions.screenWidth / 5.6,
                        padding: EdgeInsets.only(
                            top: Dimensions.height5,
                            bottom: Dimensions.height5,
                            left: Dimensions.height10,),
                        child: SmallText(
                          color: kBodyTextColor,
                          text: '$timeEstimate 分鐘',
                          fontFamily: 'NotoSansBold',
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.screenHeigt / 6.6,
                      right: Dimensions.screenWidth / 1.5,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: Dimensions.screenHeigt / 27.5,
                          padding: EdgeInsets.only(
                            top: Dimensions.height5,
                            bottom: Dimensions.height5,
                            left: Dimensions.height10,
                            right: Dimensions.height10
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(right: Dimensions.width10 / 2),
                                width: Dimensions.width15 / 2,
                                height: Dimensions.width15 / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius20,
                                  ),
                                  color: businessTime ? Colors.green : kMaimColor,
                                ),
                              ),
                              SmallText(
                                text: businessTime ? '營業中' : '尚未營業',
                                color: kBodyTextColor,
                                fontFamily: 'NotoSansMedium',
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabText(
                    text: name,
                    color: kBodyTextColor,
                    fontFamily: 'NotoSansMedium',
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabText(
                    text: address!,
                    color: kTextLightColor,
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  LocationData? currentLocation;
                  Location location = Location();
                  bool _serviceEnabled;
                  PermissionStatus _permissionGranted;

                  _serviceEnabled = await location.serviceEnabled();
                  if (!_serviceEnabled) {
                    _serviceEnabled = await location.requestService();
                    if (!_serviceEnabled) {
                      return;
                    }
                  }

                  _permissionGranted = await location.hasPermission();
                  if (_permissionGranted == PermissionStatus.denied) {
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != PermissionStatus.granted) {
                      return;
                    }
                  }

                  await location.getLocation().then((location) {
                    currentLocation = location;
                    Navigator.pushNamed(context, '/mapsplash', arguments: {
                      'currentLocation': currentLocation,
                      'initialid':id,
                    });
                  });
                  print('currentLocation');
                },
                child: Container(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'images/google-maps.png',
                    fit: BoxFit.cover,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(15, 30),
                ),
              ),
            ),
            Divider(
              thickness: Dimensions.height5,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future getcurrentLocation() async {}
}
