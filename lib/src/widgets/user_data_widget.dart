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

Widget userData(BuildContext context, IconData icono, String text){
  final size = MediaQuery.of(context).size;
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
      Icon(icono,size: 28, color: Colors.lightBlue,),
      SizedBox(width: 20,),
      Container(
        width: size.width*0.5,
        child: Text(text, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2,))
    ],
  );
}