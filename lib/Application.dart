import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  initState() {
    super.initState();
  }

  Widget getAssetImage(String path) {
    try {
      rootBundle.load(path);
      return Image.asset(path,
          width: MediaQuery.of(context).size.width - 60, fit: BoxFit.contain);
    } catch (_) {
      return SizedBox(); // return this widget
    }
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
                  Positioned(top: 20, left: 20, child: Text(colonnina.zona)),
                  Positioned(
                      top: 50, left: 20, child: Text(colonnina.posizione)),
                  Positioned(top: 90, left: 20, child: Text(colonnina.stato)),
                  Positioned(
                      top: 120,
                      left: 20,
                      child: getAssetImage('assets/images/' +
                          colonnina.index.toString() +
                          "_ok.jpg")),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      )),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SimpleGestureDetector(
        onTap: () {
          setState(() {
            //
          });
        },
        child: Scaffold(
          body: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                    initialCenter: LatLng(STARTLAT, STARTLON),
                    initialZoom: 18.2,
                    minZoom: 18.2,
                    maxZoom: 18.2,
                    interactionOptions:
                        InteractionOptions(flags: InteractiveFlag.none),
                    onTap: (event, LatLng) {
                      developer.log("Event " + event.toString());
                    }),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(markers: getMarkers())
                ],
              ),
              Positioned.fill(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).size.height - 120,
                  child: TopCard())
            ],
          ),
        ));
  }

  List<Marker> getMarkers() {
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
      point: LatLng(STARTLAT, STARTLON),
      width: 80,
      height: 80,
      child: Icon(Icons.location_on, color: Colors.red, size: 36.0),
    ));
    return _markers;
  }
}
