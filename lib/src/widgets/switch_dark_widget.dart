import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchDark extends StatefulWidget {

  @override
  _SwitchDarkState createState() => _SwitchDarkState();
}

class _SwitchDarkState extends State<SwitchDark> {

  bool _darkMode = false;

  @override
  void initState() { 
    super.initState();
    setPreferences();
  }

  Future<Null> setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('dark') ?? false;
    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
              value: _darkMode,
              title: Text('Tema oscuro'),
              subtitle: Text('Activa el modo oscuro dentro de la aplicación'), 
              onChanged: (val){
                setState(() {
                  _darkMode = val;
                  _savePreferences(context, val);
                });
              },
            );
  }

  _savePreferences(BuildContext context, bool valor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark', valor);

    final temaProvider = Provider.of<ThemeProvider>(context, listen: false);
    temaProvider.setTheme(valor);

  }


}