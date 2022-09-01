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
  }) : super(key: key);

  final String name;
  final String? address;
  final String? image;
  final int? delivertime = 0;
  final VoidCallback press;
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
                  if (delivertime != null)
                    Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.screenHeigt / 6.6,
                          left: Dimensions.screenWidth / 1.4),
                      child: Container(
                        height: Dimensions.screenHeigt / 27.5,
                        width: Dimensions.screenWidth / 5.6,
                        padding: EdgeInsets.only(
                            top: Dimensions.height5,
                            bottom: Dimensions.height5,
                            left: Dimensions.height10),
                        child: SmallText(
                          color: kBodyTextColor,
                          text: '$delivertime分鐘',
                          fontFamily: 'NotoSansBold',
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
            ListTile(
              title: TabText(
                text: name,
                color: kBodyTextColor,
                fontFamily: 'NotoSansMedium',
              ),
              subtitle: TabText(
                text: address!,
                color: kTextLightColor,
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
