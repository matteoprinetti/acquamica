import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

import 'Application.dart';
import 'DataBase.dart';
import 'StateHandler.dart';
import 'Tutorial.dart';

const double STARTLAT = 43.81869;
const double STARTLON =  7.77519;

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding
      .ensureInitialized(); // makes sure plugins are initialized
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SharedPreferences glPreferences = await SharedPreferences.getInstance();

  // if the tutorial has been seen already -> skip it

  appState startState = appState.TUTORIAL;
  bool? flagTutorial = glPreferences.getBool("tutorial_completed");
  if(flagTutorial != null && flagTutorial != false) startState = appState.MAIN;

  // Load Database


  await DataBase.init();

  // Orientation Portrait

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) =>
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => StateHandler(pState: startState) ,
      lazy: false,
    )
  ], child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>  _Home();
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: SafeArea(child:
      Consumer<StateHandler>(builder: (context, stateHandler, child) {
        // depending on the APP State, show a different content
        developer.log("State is " + stateHandler.state.toString());
        switch (stateHandler.state) {
          case appState.TUTORIAL:
            return const Tutorial();
          case appState.MAIN:
            return const Application();
          default:
            developer.log("Unhandled State " + stateHandler.state.toString());
            // TODO: Handle this case.
            return SizedBox.shrink();
        }
      }))));
}

dynamic getAppFont() {
  return GoogleFonts.getFont('Nunito',
      textStyle: TextStyle(color: Colors.blue, letterSpacing: .5));
}
