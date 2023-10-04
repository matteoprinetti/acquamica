import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

import 'StateHandler.dart';
import 'Tutorial.dart';

void main() async {

  WidgetsFlutterBinding
      .ensureInitialized(); // makes sure plugins are initialized

  SharedPreferences glPreferences = await SharedPreferences.getInstance();

  // if the tutorial has been seen already -> skip it

  appState startState = appState.TUTORIAL;
  bool? flagTutorial = glPreferences.getBool("tutorial_completed");
  if(flagTutorial != null || flagTutorial != false) startState = appState.MAIN;

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => StateHandler(pState: startState) ,
      lazy: false,
    )
  ], child: MyApp()));
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
