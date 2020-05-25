import 'package:flutter/material.dart';

class TabCameraPage extends StatefulWidget {

  @override
  _TabCameraPageState createState() => _TabCameraPageState();
}

class _TabCameraPageState extends State<TabCameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Cámara', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      backgroundColor: Colors.blue,
      body: Center(child: Text('Home Page'),),
    );
  }
}