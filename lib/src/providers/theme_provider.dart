import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{

  ThemeData _tema;
  List<ThemeData> _temas = [
    ThemeData.light(),
    ThemeData.dark().copyWith(primaryColor: Colors.indigo)
  ];

  ThemeProvider(bool t){
    if(t){
      this._tema = this._temas[1];
    }else{
      this._tema = this._temas[0];
    }
  }

  setTheme(bool t){
    if(t){
      this._tema = this._temas[1];
    }else{
      this._tema = this._temas[0];
    }
    notifyListeners();
  }

  getTheme() => this._tema;



}