import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class TabCameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  TabCameraPage(this.cameras);

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