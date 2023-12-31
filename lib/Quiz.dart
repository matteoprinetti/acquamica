import 'dart:math';

import 'package:acquamica/VideoPlayerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;

import 'DataBase.dart';
import 'main.dart';

void showQuiz(BuildContext context) {
  var _indice = Random().nextInt(DataBase.Domande.length);
  Domanda _domanda = DataBase.Domande[_indice];
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          insetPadding: EdgeInsets.all(10),
          //child: Expanded(
          child: Quiz(_domanda)));
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

class Quiz extends StatefulWidget {
  Quiz(@required this._domanda) : super();

  Domanda _domanda;

  @override
  QuizState createState() => QuizState();
}

class QuizState extends State<Quiz> with TickerProviderStateMixin {
  int _risposta = -1;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/splash_screen.png'),
          fit: BoxFit.cover,
        )),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: getBoxedText(widget._domanda.domanda, Colors.lightGreen,
                    TextStyle(fontWeight: FontWeight.bold))),
            Formulario(
              domanda: widget._domanda,
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )))),
          ],
        ));
  }
}

// Container with 3 Risposte and a text

class Formulario extends StatefulWidget {
  final Domanda domanda;
  Formulario({super.key, required this.domanda});

  @override
  State<Formulario> createState() => FormularioState();
}

class FormularioState extends State<Formulario> {
  bool isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Risposta(
        testo: widget.domanda.risposte[0],
        indice: 0,
        corretto: widget.domanda.corretta,
        active: !isAnswered,
        onSelection: getRisposta,
      ),
      Risposta(
          testo: widget.domanda.risposte[1],
          indice: 1,
          corretto: widget.domanda.corretta,
          active: !isAnswered,
          onSelection: getRisposta),
      Risposta(
          testo: widget.domanda.risposte[2],
          indice: 2,
          corretto: widget.domanda.corretta,
          active: !isAnswered,
          onSelection: getRisposta),
      SizedBox(
        height: 30,
      ),
      isAnswered
          ? Padding(
              padding: EdgeInsets.only(left: 0, right: 10),
              child: getRoundedBoxText(
                  context,
                  widget.domanda.spiegazione,
                  TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic)))
          : SizedBox(
              height: 0,
            )
    ]);
  }

  void getRisposta(int indice) {
    developer.log("Got risposta " + indice.toString());
    setState(() {
      isAnswered = true;
    });
  }
}

class Risposta extends StatefulWidget {
  final String testo;
  final int indice;
  final int corretto;
  final bool active;

  ValueSetter<int> onSelection;
  Risposta(
      {super.key,
      required this.testo,
      required this.indice,
      required this.corretto,
      required this.active,
      required this.onSelection});
  @override
  State<Risposta> createState() => RispostaState();
}

class RispostaState extends State<Risposta> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            child: Container(
                color: getBackgroundColor(),
                child: Row(children: [
                  Checkbox(
                    checkColor: Colors.green,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      if (widget.active) {
                        setState(() {
                          isChecked = value!;
                        });
                        if (value != null) widget.onSelection(widget.indice);
                      }
                    },
                  ),
                  Text(
                    widget.testo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ]))));
  }

  Color getBackgroundColor() {
    // if active, transparent
    if (widget.active) return Colors.transparent;

    // if right answer green otherwise red.

    if (widget.indice == widget.corretto) return Colors.green;

    if (widget.indice != widget.corretto && isChecked) return Colors.red;

    return Colors.transparent;
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.grey;
  }
}
