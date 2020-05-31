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