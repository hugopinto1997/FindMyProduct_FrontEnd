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

Widget NoData(IconData icono, String texto){
  return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icono, size: 64,),
            SizedBox(height: 10,),
           Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child:  Text('$texto', style: 
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
           ),

          ],
        ),
      );
}