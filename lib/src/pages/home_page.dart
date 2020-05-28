import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/pages/tabs/tab_camera_page.dart';
import 'package:prototipo_super_v2/src/pages/tabs/tab_contactos_page.dart';
import 'package:prototipo_super_v2/src/pages/tabs/tab_home_page.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';





class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _NavegacionModel(),
      child: Scaffold(
        body: _Paginas(cameras: widget.cameras,),
        bottomNavigationBar: _BottomNavigation(),
      ),
    );
  }
}


class _BottomNavigation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      onTap: (i) => navegacionModel.paginaActual = i,
      items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.all(8),
                color: (navegacionModel.paginaActual == 0) ? Colors.blueAccent : Theme.of(context).cardColor,
                child: Icon(Icons.home, color: (navegacionModel.paginaActual == 0) ? Colors.white : Theme.of(context).iconTheme.color ,),
              ),
              ),
            title: Container(),
            ),
             BottomNavigationBarItem(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.all(8),
                color: (navegacionModel.paginaActual == 1) ? Colors.blueAccent : Theme.of(context).cardColor,
                child: Icon(Icons.camera_alt, color: (navegacionModel.paginaActual == 1) ? Colors.white : Theme.of(context).iconTheme.color ,),
              ),
              ),
            title: Container(),
            ),
            BottomNavigationBarItem(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.all(8),
                color: (navegacionModel.paginaActual == 2) ? Colors.blueAccent : Theme.of(context).cardColor,
                child: Icon(Icons.perm_contact_calendar, color: (navegacionModel.paginaActual == 2) ? Colors.white : Theme.of(context).iconTheme.color ,),
              ),
              ),
            title: Container(),
            ),
        ]
      );
  }
}

class _Paginas extends StatelessWidget {
  final List<CameraDescription> cameras;
  _Paginas({@required this.cameras});

  @override
  Widget build(BuildContext context) {

    final _navegacionModel = Provider.of<_NavegacionModel>(context);

    return PageView(
      //physics: BouncingScrollPhysics(),
      controller: _navegacionModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
         
        TabHomePage(),

        TabCameraPage(cameras),        
        
        TabContactosPage(),
      ],
    );
  }
}


class _NavegacionModel with ChangeNotifier {
  int _paginaActual = 0;
  bool activo = false;
  PageController _pageController = new PageController();

  int get paginaActual => this._paginaActual;

  set paginaActual(int p){
    this._paginaActual = p;
    _pageController.animateToPage(p, duration: Duration(milliseconds: 250), curve: Curves.decelerate);
    notifyListeners();
  }

  PageController get pageController => this._pageController;

}