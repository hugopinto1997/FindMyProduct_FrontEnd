import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/utils/utils.dart';
import 'package:prototipo_super_v2/src/widgets/switch_dark_widget.dart';

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
          IconButton(icon: Icon(Icons.settings), onPressed: () {
            settingsModal(context);
          }, alignment: Alignment.centerLeft,)
        ],
      ),
      body: Center(child: Text('User Page'),),
    );
  }

  void settingsModal(BuildContext context){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Center(child: Text('Ajustes'),),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        content: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SwitchDark(),
              SizedBox(width: 0,),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Icon(Icons.power_settings_new, color: Colors.white,),
                  SizedBox(width: 20,),
                  Text('Cerrar Sesión', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),),
                ],),  
                onPressed: (){ logout(context); }
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(child: Text('Cerrar'), onPressed: () => Navigator.of(context).pop(),),
        ],
      );
    }, 
  );
}


}