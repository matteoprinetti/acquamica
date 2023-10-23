import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'StateHandler.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  int _transition = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: wait5Secs(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return Scaffold(
                backgroundColor: Color(0xfff5f7f4),
                body: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/splash_screen.png'),
                      fit: BoxFit.cover,
                    )),
                    child: AnimatedOpacity(
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 1000),
                        // The green box must be a child of the AnimatedOpacity widget.
                        child: Center(
                            child: Image.asset("assets/logoliceo.png")))));
          } else {
            // data loaded:

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Add Your Code here.

              Provider.of<StateHandler>(context, listen: false)
                  .setState(appState.TUTORIAL);
              ;
            });
            return SizedBox();
          }
        });
  }
}

Future<int> wait5Secs() async {
  await Future.delayed(Duration(seconds: 5));
  return 5;
}
