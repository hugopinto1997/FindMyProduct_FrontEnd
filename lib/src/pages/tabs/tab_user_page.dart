import 'package:flutter/material.dart';

class TabUserPage extends StatefulWidget {

  @override
  _TabUserPageState createState() => _TabUserPageState();
}

class _TabUserPageState extends State<TabUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Perfil', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () {}, alignment: Alignment.centerLeft,)
        ],
      ),
      body: Center(child: Text('User Page'),),
    );
  }
}