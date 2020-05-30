import 'package:flutter/material.dart';

class TabNotificationPage extends StatefulWidget {

  @override
  _TabNotificationPageState createState() => _TabNotificationPageState();
}

class _TabNotificationPageState extends State<TabNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Notificaciones', style: Theme.of(context).textTheme.title),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      body: Center(child: Text('Notification Page'),),
    );
  }
}