import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void showModal(BuildContext context, String error){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Ocurrió un problema'),
        content: Text('$error'),
        actions: <Widget>[
          FlatButton(child: Text('Cerrar'), onPressed: () => Navigator.of(context).pop(),),
        ],
      );
    }, 
  );
}

void logout(BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
    prefs.setInt('id', 0);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, 'login');
  }