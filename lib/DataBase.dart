import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class Colonnina {
  int index;
  String zona;
  String posizione;
  String stato;
  double Lat;
  double Long;

  Colonnina(this.index, this.zona, this.posizione, this.stato, this.Lat, this.Long);
}

class DataBase {
static List<Colonnina> Colonnine = [
  // read from fontanelle.txt file
];

static  init() async  {

  // load data

  var _fontanelleString = await rootBundle.loadString(
      "assets/fontanelle.txt");
  List<List<dynamic>> _listData =
  const CsvToListConverter().convert(_fontanelleString);

  int index  = 1;
  for (final _fontanella in _listData) {
    //developer.log("Index " + index.toString()+ ":" + _fontanella[3].toString()
    //    + ":" + _fontanella[4].toString());
    Colonnina _colonnina = Colonnina(index,
        _fontanella[0],
        _fontanella[1],
        _fontanella[2],
        _fontanella[3],
        _fontanella[4]);
    Colonnine.add(_colonnina);
    index++;
  }

}
}
