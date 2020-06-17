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