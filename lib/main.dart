import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/bloc/login_bloc.dart';
import 'package:prototipo_super_v2/src/pages/home_page.dart';
import 'package:prototipo_super_v2/src/pages/login_page.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => LoginBloc()),
      ],
      child: _MaterialChild()
    );
  }
}

class _MaterialChild extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find My Product',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
      },
      theme: ThemeData.light(),
    );
  }
}