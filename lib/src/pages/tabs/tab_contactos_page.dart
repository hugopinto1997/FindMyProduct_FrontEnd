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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/models/user_model.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

class TabContactosPage extends StatefulWidget {

  @override
  _TabContactosPageState createState() => _TabContactosPageState();
}

class _TabContactosPageState extends State<TabContactosPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    //friendsProvider.allFriends();
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn-contacts',
        onPressed: (){ Navigator.pushNamed(context, 'add_friends'); },
        child: Icon(Icons.group_add, color: Colors.white,),
        backgroundColor: Colors.blueGrey,
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
                
               },
              leading: CircleAvatar(
                child: Text('${u['username'][0].toString().toUpperCase()}'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              title: Text('${u['username']}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              //subtitle:  Text('${u['username']}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
              trailing: Icon(Icons.more_vert, color: Colors.lightBlue, size: 32,),
        ),
       ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;




}