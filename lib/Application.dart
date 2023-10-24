import 'dart:io';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import 'DataBase.dart';
import 'StateHandler.dart';
import 'TopCard.dart';
import 'main.dart';
import 'dart:developer' as developer;

class Application extends StatefulWidget {
  const Application() : super();

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application>
    with TickerProviderStateMixin {
  late int redraw;
  @override
  initState() {
    super.initState();
    redraw = 0;
  }

  Widget getAssetImage(String path) {
    rootBundle.load(path);
    return Image.asset(path,
        width: MediaQuery.of(context).size.width - 60,
        fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
      return Image.asset("assets/fontanella.jpg",
          width: MediaQuery.of(context).size.width - 60);
    });
  }

  void showColonninaInfo(BuildContext context, Colonnina colonnina) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
              insetPadding: EdgeInsets.all(10),
              //child: Expanded(
              child: Stack(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                      child: Image.asset(
                        'assets/splash_screen.png',
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                      top: 20,
                      left: 20,
                      width: MediaQuery.of(context).size.width - 60,
                      child: getBoxedText(
                          "Zona: " + colonnina.zona,
                          Colors.lightGreen,
                          TextStyle(fontWeight: FontWeight.bold))),
                  Positioned(
                      top: 80,
                      left: 40,
                      width: MediaQuery.of(context).size.width - 80,
                      child: getBoxedText(
                          colonnina.posizione,
                          Colors.lightGreenAccent,
                          TextStyle(fontWeight: FontWeight.normal))),
                  /*Positioned(
                      top: 140,
                      left: 40,
                      width: MediaQuery.of(context).size.width - 80,
                      child: getBoxedText(
                          "Stato: " + colonnina.stato,
                          Colors.lightGreenAccent,
                          TextStyle(fontWeight: FontWeight.normal))),*/
                  Positioned(
                      top: 140,
                      left: 20,
                      height: MediaQuery.of(context).size.height - 350,
                      child: getAssetImage('assets/images/fontanella' +
                          colonnina.index.toString() +
                          ".jpg")),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ))),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: colonnina.trivia == ""
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(left: 20, bottom: 16),
                              child: Material(
                                  child: Ink(
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: const BorderSide(
                                              color: Colors.green,
                                              width: 2,
                                            )),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.all(1),
                                        constraints: BoxConstraints(),
                                        iconSize: 36,
                                        icon: Image.asset("assets/curious.png"),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Curiosita'"),
                                                  content:
                                                      Text(colonnina.trivia),
                                                );
                                              });
                                        },
                                      ))))),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: colonnina.cenni == ""
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(right: 20, bottom: 16),
                              child: Material(
                                  child: Ink(
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: const BorderSide(
                                              color: Colors.green,
                                              width: 2,
                                            )),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.all(1),
                                        constraints: BoxConstraints(),
                                        iconSize: 36,
                                        icon: Image.asset(
                                            "assets/cennistorici.png"),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Cenni storici"),
                                                  content:
                                                SingleChildScrollView(
                                                child:
                                                      Text(colonnina.cenni),
                                                ));
                                              });
                                        },
                                      ))))),
                ],
              ),
            ));
  }

  List<Marker> getMarkers(Position actualPosition) {
    List<Marker> _markers = [];

    int _index = 1;
    for (var _colonnina in DataBase.Colonnine) {
      //IndexedMarker _marker = IndexedMarker(colonnina: _colonnina);

      Marker _marker = Marker(
        point: LatLng(_colonnina.Lat, _colonnina.Long),
        width: 80,
        height: 80,
        child: GestureDetector(
            onTap: () {
              developer.log("Im here" + _colonnina.Lat.toString());
              showColonninaInfo(context, _colonnina);
            },
            child: AvatarGlow(
              endRadius: 60.0,
              glowColor: Colors.blue,
              child: Material(
                // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Icon(Icons.water_drop, color: Colors.blue, size: 36.0),
                  radius: 20.0,
                ),
              ),
            )),
      );

      _markers.add(_marker);
      _index++;
    }

    // also add the current position as marker:

    _markers.add(Marker(
      point: false
          ? LatLng(STARTLAT, STARTLON)
          : LatLng(actualPosition!.latitude, actualPosition!.longitude),
      width: 80,
      height: 80,
      child: Icon(Icons.location_on, color: Colors.red, size: 48.0),
    ));
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return FutureBuilder<Position>(
        key: ValueKey(redraw),
        future: _determinePosition(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // data loaded:
            final _actualPosition = snapshot.data;
            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                        initialCenter: false
                            ? LatLng(STARTLAT, STARTLON)
                            : LatLng(_actualPosition!.latitude,
                                _actualPosition!.longitude),
                        initialZoom: 18.2,
                        minZoom: 18.2,
                        maxZoom: 18.2,
                        interactionOptions:
                            InteractionOptions(flags: InteractiveFlag.drag),
                        onTap: (event, LatLng) {
                          developer.log("Event " + event.toString());
                        }),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: getMarkers(_actualPosition))
                    ],
                  ),
                  Positioned.fill(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: MediaQuery.of(context).size.height - 120,
                      child: TopCard()),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton.small(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          // Add your onPressed code here!
                          setState(() {
                            redraw++;
                          });
                        },
                        child: const Icon(Icons.center_focus_weak),
                      ))
                ],
              ),
            );
          }
        });
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
