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
import 'package:prototipo_super_v2/src/models/user_model.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/search/search_users_delegate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriendsPage extends StatefulWidget {
final BuildContext ctx;
AddFriendsPage({@required this.ctx});

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  Map<String, dynamic> _listItem, argumentos;

  getcosa(FriendsProvider fp) async{
    final f = await fp.searchUsers('hugo');
  }
 
  @override
  Widget build(BuildContext context) {
   
    final friendsProvider = Provider.of<FriendsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Agrega un contacto', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: false,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            showSearch(
              context: context,
              delegate: DataSearch(context),
            );    
          }, alignment: Alignment.centerLeft,),
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
    fp.allUsers();
    return FutureBuilder(
      future: fp.allUsers(),
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if(snapshot.hasData){
          return _buildUser(context,snapshot.data);
        } else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildUser(BuildContext context, List<User> usrs){
     return ListView.builder(
        itemCount: usrs.length,
        itemBuilder: (context, index){
          return _userCard(context, usrs[index]);
        },
      );
  }

  Widget _userCard(BuildContext context,User u){
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
              onTap: () async { 
                final Map<String, String> r = await fp.createFriendship(u.id);
                Fluttertoast.showToast(msg: r['resp'], toastLength: Toast.LENGTH_LONG);
                Navigator.of(context).pop();
               },
              leading: CircleAvatar(
                child: Text('${u.username[0].toUpperCase()}'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              title: Text('${u.username}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              subtitle:  Text('${u.email}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
              trailing: Icon(Icons.group_add, color: Colors.lightBlue, size: 36,),
        ),
       ),
      ),
    );
  }

  




}