import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import 'StateHandler.dart';
import 'main.dart';
import 'dart:developer' as developer;

class Tutorial extends StatefulWidget {
  const Tutorial() : super();

  @override
  TutorialState createState() => TutorialState();
}

class TutorialState extends State<Tutorial>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  int pagePosition = 0;
  Widget _EndTutorialButton = new Text("");

  List<String> tutorialTexts = [
    "Ciao! Hai sete?\n" +
  "Questa app ti aiuterà a cercare la fonte d’acqua pubblica potabile più vicina alla tua"+
  "posizione in questo momento, georeferenziandoti nella zona di Sanremo.\n" +
  "Cliccando sulle gocce presenti sulla mappa, troverai la fontanella più vicina a te, potrai riconoscerla grazie " +
  "alla foto e, eventualmente, anche cenni storici riguardanti quest’ultima. Lo scopo è " +
  "sensibilizzarvi a un utilizzo più consapevole dell’acqua.",

    "Cliccando sulle gocce presenti sulla mappa, verranno suggerite le fontanelle più vicine facilmente riconoscibili dalle foto. La tua ricerca sarà accompagnata da alcune peculiarità storiche sulle fontanelle, alcune curiosità sull’acqua e alcuni consigli per un suo corretto utilizzo.",
    "L’app è stata creata dagli 'Ambasciatori dell’acqua',gli alunni delle classi 3F e 3G e Luca Prinetti (4D) a.s. 2023/2024 nell’ambito del progetto AcquaMica (Liceo G. D. Cassini Sanremo e #IoSonoAmbiente) con il prezioso aiuto del tecnico informatico Matteo Prinetti.",
    "Si ringrazia il Comune di Sanremo, l’assessore architetto Mauro Menozzi e il consigliere  Mario Robaldo, Rivieracqua S.p.a nella persona dell’ing. Paolo Ferrari. Si precisa che diverse fontanelle sono in fase di manutenzione per cui non è garantito l'approvvigionamento d’acqua."
  ];

  @override
  initState() {
    super.initState();
    pagePosition = 0;
    _animationController = AnimationController(vsync: this);
  }

  changePage(bool toForward) {
    if (toForward)
      pagePosition++;
    else
      pagePosition--;
    if (pagePosition >= tutorialTexts.length) pagePosition = 0;
    if (pagePosition < 0) pagePosition = 0;
    if (pagePosition == tutorialTexts.length - 1)
      _EndTutorialButton = getEndTutorialButton();
    else
      _EndTutorialButton = Text("");
  }

  dynamic getEndTutorialButton() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: raisedButtonStyle,
          onPressed: () {
            glPreferences.setBool("tutorial_completed",true);
            Provider.of<StateHandler>(context, listen: false)
                .setState(appState.GPS);
          },
          child: Text('Ho Capito !'),
        ));
  }



  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.yellow,
    //minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(22)),
    ),
  );

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);

      return SimpleGestureDetector(
          onTap: () {
            setState(() {
              changePage(true);
            });
          },
          onHorizontalSwipe: (SwipeDirection direction) {
            // Swiping in right direction.

            setState(() {
              developer.log("Position " + pagePosition.toString());
              if (direction == SwipeDirection.right) changePage(false);
              if (direction == SwipeDirection.left) changePage(true);
            });
          },
          child: Scaffold(
            backgroundColor: Color(0xfff5f7f4),
            body: Stack(alignment: Alignment.center, children: [
              Center(child: Image.asset("assets/sfondo.png")),
              Positioned(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.grey, width: 5),
                  ),
                  margin: EdgeInsets.only(left:16,right:16,top:16,bottom:32),
                  child: Padding(
                      padding: EdgeInsets.only(left: 16,top: 16, right: 16, bottom: 16),
                      child: Text(
                              tutorialTexts[pagePosition],
                              style: getAppFont(),
                              textScaleFactor: 1.5,
                            )
                         ),
                ),
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight * .85,
                top: ScreenUtil().screenHeight / 20,
              ),
              Positioned(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: DotsIndicator(
                      dotsCount: tutorialTexts.length,
                      position: pagePosition,
                    )),
                height: ScreenUtil().screenHeight * .13,
                bottom: 0,
              ),
              // this button only on Last page.
              Positioned(
                child: _EndTutorialButton,
                height: ScreenUtil().screenHeight * .13,
                bottom: 0,
                right: 16,
              ),
              //Your widget here,
            ]),
          ));

  }
}
