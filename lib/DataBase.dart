import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:csv/csv_settings_autodetection.dart' as csvAuto;

const d = csvAuto.FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
 
class Colonnina {
  int index;
  String zona;
  String posizione;
  String stato;
  double Lat;
  double Long;
  String trivia;
  String cenni;

  Colonnina(this.index, this.zona, this.posizione, this.stato, this.Lat,
      this.Long, this.trivia, this.cenni);
}

class Domanda {
  String domanda;
  List<String> risposte;
  int corretta;
  String spiegazione;

  Domanda(this.domanda, this.risposte, this.corretta, this.spiegazione);
}

class DataBase {
  static List<Colonnina> Colonnine = [
    // read from fontanelle.txt file
  ];
  static List<Domanda> Domande = [
    // read from domande.txt file
  ];
  static List<String> Videos = [
    "assets/videos/video_1.mp4",
    "assets/videos/video_2.mp4",
    "assets/videos/video_3.mp4",
    "assets/videos/video_4.mp4",
    "assets/videos/video_5.mp4",
    "assets/videos/video_6.mp4",
    "assets/videos/video_7.mp4",
  ];

  static init() async {
    // load data for fontanelle e domande

    var _fontanelleString =
        await rootBundle.loadString("assets/fontanelle.txt");
    List<List<dynamic>> _listData =
        const CsvToListConverter(fieldDelimiter: ";",csvSettingsDetector: d).convert(_fontanelleString);

    int index = 1;
    for (final _fontanella in _listData) {
      //developer.log("Index " + index.toString()+ ":" + _fontanella[3].toString()
       //   + ":" + _fontanella[4].toString());
      Colonnina _colonnina = Colonnina(
        index,
        _fontanella[0],
        _fontanella[1],
        _fontanella[2],
        _fontanella[3],
        _fontanella[4],
        _fontanella.length >= 6 ? _fontanella[5] : "",
        _fontanella.length >= 7 ? _fontanella[6] : "",
      );
      Colonnine.add(_colonnina);
      index++;
    }

    // load data for fontanelle e domande

    var _domandeString = await rootBundle.loadString("assets/domande.txt");
    List<List<dynamic>> _listDomande =
        const CsvToListConverter(fieldDelimiter: ";",csvSettingsDetector: d).convert(_domandeString);

    index = 1;
    for (final _domandaRaw in _listDomande) {
      Domanda _domanda = Domanda(
          _domandaRaw[0],
          [
            _domandaRaw[1].toString(),
            _domandaRaw[2].toString(),
            _domandaRaw[3].toString()
          ],
          int.parse(_domandaRaw[4].toString()),
          _domandaRaw[5]);
      Domande.add(_domanda);
      index++;
    }
  }
}
