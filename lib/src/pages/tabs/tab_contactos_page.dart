import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';

class TabContactosPage extends StatefulWidget {

  @override
  _TabContactosPageState createState() => _TabContactosPageState();
}

class _TabContactosPageState extends State<TabContactosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Contactos', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}, alignment: Alignment.centerLeft,),
        ],
      ),
      body:  NoData(Icons.perm_contact_calendar, 'No tiene ningún contacto guardado'),
    );
  }
}