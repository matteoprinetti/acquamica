import 'package:avatar_glow/avatar_glow.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import 'StateHandler.dart';
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
                    initialCenter: LatLng(43.81869, 7.77519),
                    initialZoom: 18.2,
                    minZoom: 18.2,
                    maxZoom: 18.2,
                    interactionOptions:
                        InteractionOptions(flags: InteractiveFlag.none
                            //.all &
                            //~InteractiveFlag.rotate &
                            //~InteractiveFlag.drag &
                            // ~InteractiveFlag.pinchMove &
                            //  ~InteractiveFlag.pinchZoom
                            )),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(43.81869, 7.77519),
                        width: 80,
                        height: 80,
                        child: AvatarGlow(
                          endRadius: 60.0,
                          glowColor: Colors.blue,
                          child: Material(
                            // Replace this child with your own
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              child: SimpleGestureDetector(
                                  onTap: () {
                                    showWaterInfo(context);
                                  },
                                  child: Icon(Icons.water_drop,
                                      color: Colors.blue, size: 36.0)),
                              radius: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void showWaterInfo(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>  Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('This is a fullscreen dialog.'),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    )));
  }
}

