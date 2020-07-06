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