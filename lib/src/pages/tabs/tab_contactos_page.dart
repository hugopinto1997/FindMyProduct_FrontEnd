import 'package:flutter/material.dart';

class TabContactosPage extends StatefulWidget {

  @override
  _TabContactosPageState createState() => _TabContactosPageState();
}

class _TabContactosPageState extends State<TabContactosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Contactos', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      backgroundColor: Colors.green,
      body: Center(child: Text('Home Page'),),
    );
  }
}