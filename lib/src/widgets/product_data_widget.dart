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

Widget ProductData(String texto){
  return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage('https://www.nicepng.com/png/full/175-1759066_pepsi-2-liter-png-pepsi-1-5-l.png'),
                     height: 50.0, width:50.0,
                     fit: BoxFit.cover,
                    ),
                ),
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