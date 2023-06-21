import 'package:cached_network_image/cached_network_image.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo02/models/BigText.dart';

import 'package:flutterdemo02/models/ColorSettings.dart';
import 'package:flutterdemo02/models/MiddleText.dart';
import 'package:flutterdemo02/models/SmallText.dart';
import 'package:flutterdemo02/models/TabsText.dart';
import 'package:flutterdemo02/pages/MapSplash.dart';
import 'package:flutterdemo02/provider/custom_page_route.dart';
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
    required this.businessStartTime,
  }) : super(key: key);

  final String name;
  final String? address;
  final String? image;
  final String? timeEstimate;
  final bool businessTime;
  final int? businessStartTime;
  final VoidCallback press;
  final String id;
  List? discount = [];
  @override
  Widget build(BuildContext context) {
    print('image of store is ${image}');
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
                  CachedNetworkImage(
                    imageUrl: image!,
                    errorWidget: (context, url, error) {
                      print('error is $error');
                      if (error) {
                        print('error is $error');
                        return Container(
                          width: Dimensions.screenWidth,
                          height: Dimensions.screenHeigt / 4.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                Dimensions.radius15,
                              ),
                            ),
                            color: Colors.grey,
                            image: const DecorationImage(
                              image: AssetImage(
                                'images/preImage.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: Dimensions.screenWidth,
                          height: Dimensions.screenHeigt / 4.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                Dimensions.radius15,
                              ),
                            ),
                            color: Colors.grey,
                            image: const DecorationImage(
                              image: AssetImage(
                                'images/preImage.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                    progressIndicatorBuilder: (context, url, progress) =>
                        Container(
                      width: Dimensions.screenWidth,
                      height: Dimensions.screenHeigt / 4.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Dimensions.radius15,
                          ),
                        ),
                        color: Colors.grey,
                        image: const DecorationImage(
                          image: AssetImage(
                            'images/preImage.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      width: Dimensions.screenWidth,
                      height: Dimensions.screenHeigt / 4.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Dimensions.radius15,
                          ),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
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
                          left: Dimensions.height10,
                        ),
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
                  if (businessTime == false)
                    Container(
                      height: Dimensions.screenHeigt / 4.85,
                      width: Dimensions.screenWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Center(
                        child: BigText(
                          color: Colors.white,
                          text: businessStartTime != null
                              ? businessStartTime == 0
                                  ? '00:00 開始營業'
                                  : '$businessStartTime:00 開始營業'
                              : '店家今天已不營業了!',
                          fontFamily: 'NotoSansMedium',
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
                            right: Dimensions.height10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: Dimensions.width10 / 2),
                                width: Dimensions.width15 / 2,
                                height: Dimensions.width15 / 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radius20,
                                  ),
                                  color:
                                      businessTime ? Colors.green : kMaimColor,
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
                    Navigator.push(
                      context,
                      CustomPageRoute(
                        child: MapSplash(
                          arguments: {
                            'currentLocation': currentLocation,
                            'initialid': id,
                          },
                        ),
                      ),
                    );
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
