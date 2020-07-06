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
import 'package:prototipo_super_v2/src/bloc/login_bloc.dart';
import 'package:prototipo_super_v2/src/pages/add_friends_page.dart';
import 'package:prototipo_super_v2/src/pages/add_product_to_list_page.dart';
import 'package:prototipo_super_v2/src/pages/home_page.dart';
import 'package:prototipo_super_v2/src/pages/list_add_friend_page.dart';
import 'package:prototipo_super_v2/src/pages/list_detail_page.dart';
import 'package:prototipo_super_v2/src/pages/login_page.dart';
import 'package:prototipo_super_v2/src/pages/register_page.dart';
import 'package:prototipo_super_v2/src/pages/tabs/tab_camera_page.dart';
import 'package:prototipo_super_v2/src/providers/camera_provider.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
import 'package:prototipo_super_v2/src/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
List<CameraDescription> cameras;
SharedPreferences prefs;
String pagina;
bool currentTheme;
int loggedUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  pagina = prefs.getString('token') ?? '';
  currentTheme = prefs.getBool('dark') ?? false;
  loggedUser = prefs.getInt('id');

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => LoginBloc()),
        ChangeNotifierProvider(create: (_) => ListsActionCableProvider(loggedUser, pagina)),
        Provider(create: (_) => FriendsProvider(pagina)),
        Provider(create: (_) => ProductsProvider(loggedUser, pagina),),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(currentTheme),
        ),
        ChangeNotifierProvider(
          create: (_) => CameraProvider(),
        ),
      ],
      child: _MaterialChild()
    );
  }
}

class _MaterialChild extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find My Product',
      initialRoute: (pagina.isEmpty) ? 'login' : 'home',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'home': (BuildContext context) => HomePage(cameras),
        'camara': (BuildContext context) => TabCameraPage(cameras),
        'listDetail': (BuildContext context) => ListDetail(ctx: context,),
        'add_friends': (BuildContext context) => AddFriendsPage(ctx: context,),
        'add_product': (BuildContext context) => AddProductToListPage(ctx: context,),
        'add_list_friend': (BuildContext context) => ListAddFriend(),
      },
      theme: theme.getTheme(),
    );
  }
}