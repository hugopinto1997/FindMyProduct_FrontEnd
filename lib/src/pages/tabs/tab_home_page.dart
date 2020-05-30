import 'dart:convert';

import 'package:action_cable_stream/action_cable_stream.dart';
import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:flutter/material.dart';

class TabHomePage extends StatefulWidget {

  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> with AutomaticKeepAliveClientMixin {
  ActionCable _cable2;
  final String _channel = "List";
  String actioncableurl = 'wss://findmyproduct-api.herokuapp.com/api/v1/cable';


  @override
  void initState() {
    super.initState();

    _cable2 = ActionCable.Stream(actioncableurl);
    _cable2.stream.listen((value) {
        if (value is ActionCableConnected) {
          _cable2.subscribeToChannel(_channel, channelParams: {'room': "private"});
         print('ActionCableConnected');
        } else if (value is ActionCableSubscriptionConfirmed) {
          print('ActionCableSubscriptionConfirmed');
          _cable2.performAction(_channel, 'message',
              channelParams: {'room': "private"},actionParams: {'id': 1});
        } else if (value is ActionCableMessage) {
          print('ActionCableMessage ${jsonEncode(value.message)}');
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _cable2.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus listas', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _cable2.stream,
              initialData: ActionCableInitial(),
              builder: (context, AsyncSnapshot<ActionCableDataState> snapshot){
                  if(snapshot.hasData){
                    return buildBody(snapshot, context);
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
      },
    ),
          ),
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){ },
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.add, color: Colors.white,),
        ),
    );
  }

 Widget buildBody(AsyncSnapshot<ActionCableDataState> snapshot, BuildContext context) {
    final state = snapshot.data;

    
    if (state is ActionCableInitial ||
        state is ActionCableConnectionLoading ||
        state is ActionCableSubscribeLoading) {
      return Center(child: CircularProgressIndicator(),);
    } else if (state is ActionCableError) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ActionCableSubscriptionConfirmed) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ActionCableSubscriptionRejected) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ActionCableMessage) {
         final ej = json.decode(jsonEncode(state.message));
         List<dynamic> res = ej["message"];
        
         return ListView.builder(
           itemCount: res.length ?? 0,
           itemBuilder: (context, index){
             return _listaMap(context, res[index]);
           },
         );
         //return Text('${res}');
    } else if (state is ActionCableDisconnected) {
      return Text('Disconnected');
    } else {
      return Text('Something went wrong');
    }
  }

  Widget _listaMap(BuildContext context,Map<String, dynamic> user){
        return Container(
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Theme.of(context).cardColor,
                margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                elevation: 5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child: ListTile(
                    onTap: () { Navigator.pushNamed(context, 'listDetail'); },
                    leading: Icon(Icons.shopping_cart, color: Colors.indigo, size: 48),
                    title: Text(user['name'], style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
                    subtitle:  Text('Productos seleccionados: ${user['quantity'].toString()}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.lightBlue, size: 12,),
                  ),
                ),
              ),
                );
  }

  @override
  bool get wantKeepAlive => true;
}