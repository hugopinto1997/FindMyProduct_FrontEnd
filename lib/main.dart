import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/bloc/login_bloc.dart';
import 'package:prototipo_super_v2/src/pages/home_page.dart';
import 'package:prototipo_super_v2/src/pages/list_detail_page.dart';
import 'package:prototipo_super_v2/src/pages/login_page.dart';
import 'package:prototipo_super_v2/src/pages/tabs/tab_camera_page.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

 
List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
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
        Provider(create: (_) => ListsActionCableProvider(1)),
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
      initialRoute: 'home',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(cameras),
        'camara': (BuildContext context) => TabCameraPage(cameras),
        'listDetail': (BuildContext context) => ListDetail(ctx: context,),
      },
      theme: ThemeData.dark(),
    );
  }
}