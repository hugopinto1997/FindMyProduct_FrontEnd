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
import 'package:prototipo_super_v2/src/providers/camera_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:prototipo_super_v2/src/widgets/product_data_widget.dart';
import 'package:provider/provider.dart';
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
  String _objeto = "";
    String _opcionSeleccionada = 'Gansito';
  List<String> _productos = ['Pepsi','Flan Royale','Gansito', 'Margarina Mazola', 'Jugo Frutsi', 'Avena Quaker', 'Pan Bimbo', 'Coca Cola'];

  List<DropdownMenuItem<String>> getOpts() {
        List<DropdownMenuItem<String>> lista = new List();

        _productos.forEach((poder){
          lista.add(DropdownMenuItem(
            child: Text(poder),
            value: poder,
            )
          );
        });
        return lista;
    }

    Widget _crearDropdown(CameraProvider campro){
    return Row(
      children: <Widget>[
        Icon(Icons.select_all),
        SizedBox(width: 10.0,),
        Expanded(
        child: 
          DropdownButton(
            value: _opcionSeleccionada,
            items: getOpts(),
            onChanged: (opt){
            setState(() {
              campro.setLoad(opt);
              campro.setObjeto('');
              _opcionSeleccionada=opt;
            });
            },
          ),
        )
      ],
    );
  }

   @override
  void initState() {
    super.initState();
  }

  String getPhoto(String img){
    if(img == 'pepsi'){
      return 'https://www.nicepng.com/png/full/175-1759066_pepsi-2-liter-png-pepsi-1-5-l.png';
    } else if (img == 'gansito'){
      return 'https://3.bp.blogspot.com/-eOZkDETgBx0/Wim5rCVXQMI/AAAAAAAAARo/eLXzVN1UKRoQ_FLp8lCl3_0JvGoj4HChQCK4BGAYYCw/s1600/gancito%2B3.png';
    }
  }

  loadModel() async {
      await Tflite.loadModel(
        model: "assets/custom-voc.tflite",
        labels: "assets/custom-voc.txt");
  }

  loadModelGansito() async {
      await Tflite.loadModel(
        model: "assets/gansitoModel.tflite",
        labels: "assets/labels.txt");
  }

   

  onSelect(BuildContext contexto) {
    final cp = Provider.of<CameraProvider>(context, listen: false);
    setState(() {
      //_model = "PEPSI";
      cp.setModel(cp.getLoad());
      //Fluttertoast.showToast(msg: 'Comencemos a buscar a ${cp.getModel()}!', toastLength: Toast.LENGTH_LONG);
      //_objeto = "f";
    });
    if(cp.getModel() == 'Pepsi'){
      loadModel();
    }else{
      loadModelGansito();
    }
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
              child: _crearDropdown(camProvider),
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
                      image: NetworkImage(getPhoto(camProvider.getLoad().toString().toLowerCase())),
                     height: 200.0, width:200.0,
                     fit: BoxFit.cover,
                    ),
            SizedBox(height: 10,),
            Container(
              width: screen.width*0.7,
              child: Text('${camProvider.getObjeto()}', style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10,),
            Container(
              width: screen.width*0.7,
              child: Text('Se reconoció con ${camProvider.getConfidence()}% de confianza', style: Theme.of(context).textTheme.subtitle1, textAlign: TextAlign.center,),
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
              screen.width
              ),
        ],
      ),
    );
  }
}