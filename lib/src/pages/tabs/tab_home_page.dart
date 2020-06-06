import 'dart:convert';

import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';

class TabHomePage extends StatefulWidget {
  BuildContext ctx;
  TabHomePage({this.ctx});

  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> with AutomaticKeepAliveClientMixin {

  ListsActionCableProvider listCable;


  @override
  void initState() { 
    super.initState();
    listCable = Provider.of<ListsActionCableProvider>(widget.ctx);
    listCable.initCable();
  }

@override
  void dispose() {
    super.dispose();
    /* Even if this Widget uses the mixin to keep alive, eventually the cache memory of the phone could get full and the widget should start its lifecycle again (That's why I called initCable inside initState) */
    print('Disposed Action Cable');
    listCable.disposeCable();
  }


  @override
  Widget build(BuildContext context) {
    listCable = Provider.of<ListsActionCableProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus listas', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: listCable.getCable().stream,
                initialData: ActionCableInitial(),
                builder: (context, AsyncSnapshot<ActionCableDataState> snapshot){
                    if(snapshot.hasData){
                      return buildBody(snapshot, context);
                    }else{
                      return NoData(Icons.format_list_bulleted, 'No tienes ninguna lista');
                    }
        },
    ),
            ),
          ],
          ),
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
       List<dynamic> res = json.decode(ej['message'])['info'];
       
        if(res.length == 0){
          return NoData(Icons.format_list_bulleted, 'No tienes ninguna lista');
        }else{
          return ListView.builder(
           itemCount: res.length ?? 0,
           itemBuilder: (context, index){
             return _listaMap(context, res[index], index);
           },
         );
        }
         
        // return Text('${res[0]}');
    } else if (state is ActionCableDisconnected) {
      return Text('Disconnected');
    } else {
      return Text('Something went wrong');
    }
  }

  Widget _listaMap(BuildContext context,Map<String, dynamic> listItem, int index){
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
                    onTap: () { Navigator.pushNamed(context, 'listDetail', arguments: {'listItem': listItem, 'index': index}); },
                    leading: Icon(Icons.shopping_cart, color: Colors.indigo, size: 48),
                    title: Text(listItem['name'], style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
                    subtitle:  Text('Productos seleccionados: ${listItem['products'].length}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.lightBlue, size: 12,),
                  ),
                ),
              ),
                );
  }

  @override
  bool get wantKeepAlive => true;
}