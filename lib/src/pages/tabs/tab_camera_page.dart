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
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera_utils/bndbox.dart';
import 'camera_utils/camera.dart';

class TabCameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  TabCameraPage(this.cameras);

  @override
  _TabCameraPageState createState() => _TabCameraPageState();
}

class _TabCameraPageState extends State<TabCameraPage> {

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

   @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/custom-voc.tflite",
        labels: "assets/custom-voc.txt");
  }

  onSelect() {
    setState(() {
      _model = "PEPSI";
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    //onSelect();
    return Scaffold(
       appBar: AppBar(
        title: Text('Cámara', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          FlatButton(child: (_model != "") ? Text("Reset", style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white),) : null,
            onPressed: (){
              setState(() {
                _model = "";
              });
            },
          ),
        ],
      ),
      body: _model == ""
          ? new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.camera),
                      color: Colors.blue,
                      onPressed: () => onSelect(),
                    ),
                    Text('Pepsi: Presentación Botella 1,5 mL'),
                  ],
                )
            ),
          ],
        ),
      )
          : new Stack(
        children: [
          Camera(
            widget.cameras,
            setRecognitions,
          ),
          BndBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
        ],
      ),
    );
  }
}