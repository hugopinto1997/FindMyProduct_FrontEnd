import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';

class TabNotificationPage extends StatefulWidget {

  @override
  _TabNotificationPageState createState() => _TabNotificationPageState();
}

class _TabNotificationPageState extends State<TabNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Notificaciones', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      body: NoData(Icons.notifications_off, 'No tienes ninguna notificación'),
    );
  }
}