import 'package:acquamica/VideoPlayerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'DataBase.dart';

void showQuiz(BuildContext context) {
  Domanda _domanda = DataBase.Domande[0];
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(10),
            //child: Expanded(
             child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)),
          child: Container(color: Colors.black12, child: Padding(
              padding: EdgeInsets.all(16.0),
              child:Text(_domanda.domanda)))),
                 Text(_domanda.risposte[0]),
                Expanded( child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ))),
              ],
            ),
          ));
}

void showVideo(BuildContext context) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(10),
            //child: Expanded(
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Use a FutureBuilder to display a loading spinner while waiting for the
// VideoPlayerController to finish initializing.
                VideoPlayerScreen()
              ],
            ),
          ));
}
