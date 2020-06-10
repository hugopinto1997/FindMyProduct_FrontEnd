import 'package:flutter/material.dart';

Widget userData(BuildContext context, IconData icono, String text){
  return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Icon(icono,size: 28, color: Colors.lightBlue,),
      SizedBox(width: 20,),
      Text(text, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2)
    ],
  );
}