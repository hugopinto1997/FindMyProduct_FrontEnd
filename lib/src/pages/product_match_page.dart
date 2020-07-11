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
import 'package:prototipo_super_v2/src/pages/tabs/camera_utils/bndbox.dart';
import 'package:prototipo_super_v2/src/pages/tabs/camera_utils/camera.dart';
import 'package:prototipo_super_v2/src/providers/camera_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;


class ProductMatchPage extends StatefulWidget {
final List<CameraDescription> cameras;
  ProductMatchPage(this.cameras);
  @override
  _ProductMatchPageState createState() => _ProductMatchPageState();
}

class _ProductMatchPageState extends State<ProductMatchPage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";
  String _objeto = "";

   @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/custom-voc.tflite",
        labels: "assets/custom-voc.txt");
  }

  onSelect(BuildContext contexto) {
    final cp = Provider.of<CameraProvider>(context, listen: false);
    setState(() {
      //_model = "PEPSI";
      cp.setModel("PEPSI");
      //_objeto = "f";
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
    final camProvider = Provider.of<CameraProvider>(context);
    //onSelect();
    //_objeto = "f";
    return Scaffold(
       appBar: AppBar(
        title: Text('Cámara', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          FlatButton(child: (camProvider.getModel() != "") ? Text("Reset", style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),) : null,
            onPressed: (){
              setState(() {
                //_model = "";
                camProvider.setModel("");
                //_objeto = "f";
              });
            },
          ),
        ],
      ),
      body: camProvider.getModel() == ""
          ? 
          (camProvider.getObjeto() == "") ?
             new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NoData(Icons.camera_enhance, "¡Detecta un producto!"),
            SizedBox(height: 10,),
            Container(
              width: screen.width*0.7,
              child: Text('¡Utiliza el reconocimiento de objetos a través de la cámara de tu dispositivo para hacer tu experiencia más práctica y confortable!', style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,),
            ),
            SizedBox(height: 30,),
            Container(
              width: screen.width*0.6,
              height: 45,
              child: RaisedButton(
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: (){
                  onSelect(context);
                  setState(() {
                    
                  });
                },
                child: Text('Detectar objeto', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
              ),
            ),
          ],
        ),
      )
      :  new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //ProductData("Pepsi 1.5L"),
            FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage('https://www.nicepng.com/png/full/175-1759066_pepsi-2-liter-png-pepsi-1-5-l.png'),
                     height: 200.0, width:200.0,
                     fit: BoxFit.cover,
                    ),
            SizedBox(height: 10,),
            Container(
              width: screen.width*0.7,
              child: Text('Pepsi 1.5L', style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),
            Container(
              width: screen.width*0.7,
              child: Text('Se ha reconocido una Pepsi de 1.5L, era este su objeto? ${camProvider.getConfidence()}', style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20,),
            Container(
              width: screen.width*0.6,
              height: 45,
              child: RaisedButton(
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: (){
                  camProvider.setObjeto("");
                  setState(() {
                    
                  });
                },
                child: Text('Volver', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
              ),
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
              camProvider.getModel(),
              camProvider.getObjeto()
              ),
        ],
      ),
    );
  }
}