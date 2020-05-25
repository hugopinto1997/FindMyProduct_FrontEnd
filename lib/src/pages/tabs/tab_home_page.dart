import 'package:flutter/material.dart';

class TabHomePage extends StatefulWidget {

  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus listas', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      backgroundColor: Colors.red,
      body: Center(child: Text('Home Page'),),
    );
  }
}