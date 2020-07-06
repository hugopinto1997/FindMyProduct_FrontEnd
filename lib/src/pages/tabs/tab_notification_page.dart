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
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

class TabNotificationPage extends StatefulWidget {

  @override
  _TabNotificationPageState createState() => _TabNotificationPageState();
}

class _TabNotificationPageState extends State<TabNotificationPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);
    return Scaffold(
       appBar: AppBar(
        title: Text('Notificaciones', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
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
    fp.friendRequests();
    return FutureBuilder(
      future: fp.friendRequests(),
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){    
          return _buildUser(context, snapshot.data);                 
        } else{
          return Center(child: CircularProgressIndicator(),);
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
            return _userRequestCard(context, usrs[index]);
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

Widget _userRequestCard(BuildContext context,Map u){
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
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    child: Text('${u['username'][0].toString().toUpperCase()}', style: TextStyle(color: Colors.white, fontSize: 24),),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
              title: Text(' \'${u['username']}\' quiere ser tu amigo', textAlign: TextAlign.start,maxLines: 2, style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              subtitle: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 40,
                //color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () async {
                          final String r = await fp.acceptRequest(u['friendship_id'].toString(), u['user_id'].toString() );
                          Fluttertoast.showToast(msg: r, toastLength: Toast.LENGTH_LONG);
                          setState(() {
                            
                          });
                        },
                        child: Text('Aceptar', style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () async {
                          final String r = await fp.deleteRequest(u['friendship_id'].toString());
                          Fluttertoast.showToast(msg: r.toString(), toastLength: Toast.LENGTH_LONG);
                          setState(() {
                            
                          });

                        },
                        child: Text('Rechazar', style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              //trailing: Icon(Icons.info_outline, color: Colors.lightBlue, size: 36,),
        ),
       ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}