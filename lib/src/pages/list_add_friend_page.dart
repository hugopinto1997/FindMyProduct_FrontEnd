import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/models/user_model.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

class ListAddFriend extends StatefulWidget {

  @override
  _ListAddFriendState createState() => _ListAddFriendState();
}

class _ListAddFriendState extends State<ListAddFriend> {
  Map<String, dynamic> _listItem, argumentos;




  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
     argumentos = ModalRoute.of(context).settings.arguments;
    _listItem = argumentos['listItem'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar amigo', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: false,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.search), onPressed: () {}, alignment: Alignment.centerLeft,),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Expanded(child: _buildFriends(context, friendsProvider)),
          ],
        ),
      ),
    );
  }

Widget _buildFriends(BuildContext context, FriendsProvider fp) {
    fp.allFriends();
    return FutureBuilder(
      future: fp.allFriends(),
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return _buildUser(context,snapshot.data);
        } else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildUser(BuildContext context, List usrs){
     return RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
          itemCount: usrs.length,
          itemBuilder: (context, index){
            return _userCard(context, usrs[index]);
          },
        ),
     );
  }

  Future<Null> refresh() async {
    final duration = new Duration(
      seconds: 1
    );
    Timer(duration, (){
      setState(() {
        
      });
    });
    return Future.delayed(duration);
  }

  Widget _userCard(BuildContext context,Map u){
    final fp = Provider.of<FriendsProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          elevation: 5.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
              child: ListTile(
              onTap: () { 
                  _agregarAmigo(context, u['user_id'], u['username']);
               },
              leading: CircleAvatar(
                child: Text('${u['username'][0].toString().toUpperCase()}'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              title: Text('${u['username']}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              //subtitle:  Text('${u['username']}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
              trailing: Icon(Icons.add, color: Colors.lightBlue, size: 32,),
        ),
       ),
      ),
    );
  }


_agregarAmigo(BuildContext context, int userid, String username) {
  final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('¿Estás seguro?'),
        content: Text('Deseas agregar a $username a la lista ${_listItem['name']}'),
        actions: <Widget>[
          FlatButton(child: Text('Agregar a la lista'), 
          onPressed: () {
            Fluttertoast.showToast(msg: 'Usuario añadido exitosamente!', toastLength: Toast.LENGTH_LONG);
          addUser(userid, _listItem['name'].toString(), listProvider);
           Navigator.of(context).pop();
           Navigator.of(context).pop();
          }),
          FlatButton(child: Text('Cerrar'), onPressed: () => Navigator.of(context).pop(),),
        ],
      );
    }, 
  );
}

addUser(int listId, String username, ListsActionCableProvider listProv) async {
  String r = await listProv.addFriend(listId, username);
}


}