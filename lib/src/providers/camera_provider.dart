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

class CameraProvider with ChangeNotifier{

  String _objeto;
  String _model;
  String _percentage;
  String _load;

  CameraProvider(){
    this._objeto = "";
    this._model = "";
    this._percentage = "";
    this._load = '';
  }

  setObjeto(String o){
    this._objeto = o;
    notifyListeners();
  }

  setLoad(String o){
    this._load = o;
    notifyListeners();
  }

  setConfidence(String p){
    this._percentage = p;
    //notifyListeners();
  }

  setModel(String m){
    this._model = m;
    notifyListeners();
  }

  getObjeto() => this._objeto;

  getConfidence() => this._percentage;

  getModel() => this._model;

  getLoad() => this._load;


}