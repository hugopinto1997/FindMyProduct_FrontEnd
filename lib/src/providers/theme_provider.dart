/*
 * FindMyProduct app
 * Copyright (C) 2020 hugopinto1997
 *
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>
 */

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