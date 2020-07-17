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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/models/user_profile_model.dart' as UserProfile;
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/providers/usuario_provider.dart';
import 'package:prototipo_super_v2/src/utils/utils.dart';
import 'package:prototipo_super_v2/src/widgets/switch_dark_widget.dart';
import 'package:prototipo_super_v2/src/widgets/user_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabUserPage extends StatefulWidget {
  final BuildContext context;
  TabUserPage({this.context});
  @override
  _TabUserPageState createState() => _TabUserPageState();
}

class _TabUserPageState extends State<TabUserPage> with AutomaticKeepAliveClientMixin {
  UsuarioProvider usuario = new UsuarioProvider();
  SharedPreferences prefs;
  UserProfile.User u = new UserProfile.User(email: '', phone: '', username: 'f');
  List friends, requests;
  FriendsProvider amigos; 


  @override
  void initState() {
    super.initState();
    initProfile();
  }

  initProfile() async {
    amigos = Provider.of<FriendsProvider>(widget.context);
    prefs = await SharedPreferences.getInstance();
    u = await usuario.perfil(prefs.getInt('id'), prefs.getString('token'));
    friends = await amigos.allFriends();
    requests = await amigos.friendRequests();
    setState(() {
      
    });
  }

  refreshProfile() async {
    u = await usuario.perfil(prefs.getInt('id'), prefs.getString('token'));
    friends = await amigos.allFriends();
    requests = await amigos.friendRequests();
    setState(() {
    });
  }

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
          }, alignment: Alignment.centerLeft,),
        ],
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 10),
          icon: Icon(Icons.update), onPressed: () {
            refreshProfile();
            Fluttertoast.showToast(msg: 'Perfil actualizado!', toastLength: Toast.LENGTH_SHORT);
          }, alignment: Alignment.center,),
      ),
      body: (u.email.isEmpty || u.phone.isEmpty) ? Center(child: CircularProgressIndicator(),) : 
      Stack(
        children: <Widget>[
          _crearFondo(context),
          _perfil(context),
        ],
      ),
    );
  }


Widget _crearFondo(BuildContext context){
  final size = MediaQuery.of(context).size;

  final fondoSuperior = Container(
    height: size.height*0.2,
    margin: EdgeInsets.only(left: 10, right: 10, top: 12),
    width: double.infinity,
    child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage('https://images.theconversation.com/files/223713/original/file-20180619-38837-1t04rux.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=496&fit=clip')),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color.fromRGBO(6, 66, 186, 1.0),
          Color.fromRGBO(56, 114, 232, 1.0),
        ],
        ),
    ),
  );


    return Stack(
      children: <Widget>[
        fondoSuperior,

      
      ],
    );

}

Widget _perfil(BuildContext context){
  final size = MediaQuery.of(context).size;
  final isPortrait = MediaQuery.of(context).orientation;
  bool screenMode = (isPortrait == Orientation.portrait) ? true : false;

  return SingleChildScrollView(
      child: Column(
              children: <Widget>[
                 SafeArea(child: Container(height: (screenMode) ? 80 : 10)),

                CircleAvatar(
                  backgroundColor: Colors.white, 
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(158, 27, 27, 1),
                    radius: 62,
                    child: Text('${u.username[0].toUpperCase()}', style: TextStyle(color: Colors.white, fontSize: 64),),
                  ),
                  radius: 64,
                  foregroundColor: Colors.white
                ),
                
                SizedBox(height: 20, width: double.infinity,),
                Text('${u.username}', style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 28),),
                
                SizedBox(height: 28,),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(width: size.width*0.8, height: 36, color: Colors.blueGrey,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                    Icon(Icons.shopping_cart, color: Colors.white,),
                    SizedBox(width: 20,),
                    Text('Tienes ${u.lists.length} listas disponibles', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),)
                  ],),
                  )),

                SizedBox(height: 20,),

                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                    width: size.width*0.8,
                    color: Theme.of(context).cardColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: <Widget>[
                        userData(context, Icons.mail, '${u.email}'),
                        SizedBox(height: 10),
                         userData(context, Icons.phone_iphone, '${u.phone}'),
                          SizedBox(height: 10),
                         userData(context, Icons.people, 'Tienes ${friends.length} amigos'),
                          SizedBox(height: 10),
                         userData(context, Icons.people_outline, 'Tienes ${requests.length} solicitudes'),
                      ],
                    ),
                  ),
                ),  
              
                
              ],
            ),
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

  @override
  bool get wantKeepAlive => true;


}