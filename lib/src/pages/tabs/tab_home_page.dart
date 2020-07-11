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
import 'dart:convert';

import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
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
  TextEditingController controller;
  String _texto = '';

  @override
  void initState() {
    print('inicializado HOME PAGE...'); 
    super.initState();
    _texto = '';
    listCable = Provider.of<ListsActionCableProvider>(widget.ctx);
    //listCable.getUserLists();
    listCable.initCable();
    controller = TextEditingController();
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
   // print('Building HOME PAGE...');
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
                      return buildBody(snapshot, context, listCable);
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
          onPressed: (){ 
            createList(context, 'aber');
          },
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.add, color: Colors.white,),
        ),
    );
  }

 Widget buildBody(AsyncSnapshot<ActionCableDataState> snapshot, BuildContext context, ListsActionCableProvider listProvider)  {
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
       print('vine aqui HOME...');
       final ej = json.decode(jsonEncode(state.message));
       List<dynamic> res = json.decode(ej['message'])['info'];
       //Map<String, dynamic> mapa = res[0]['users'][0];
       List r = filterByUser(res, listProvider);

          return RefreshIndicator(
             onRefresh: refresh,
             child: ListView.builder(
             itemCount: r.length ?? 0,
             itemBuilder: (context, index){
               return _listaMap(context, r[index], index);
             },
         ),
        );
        //print(prods);       
       // return Text('${r}');
    } else if (state is ActionCableDisconnected) {
      return Text('Disconnected');
    } else {
      return Text('Something went wrong');
    }
  }

  List filterByUser(List lista, ListsActionCableProvider lp){
    List filtered_list = new List();
    lista.forEach((element) {
      List users = element['users'];
      users.forEach((usuario) {
        Map<String, dynamic> user = usuario;
        if(user['user_id'] == lp.userIdentifier){
          filtered_list.add(element);
        }
       });
     });
    return filtered_list;
  }

  Future<List> cargar(ProductsProvider p) async{
    final List resp = await p.getAllProducts();
    return resp;
  }

  Future<Null> refresh() async {
    final duration = new Duration(
      seconds: 1
    );
    Timer(duration, (){
      setState(() {
        listCable.initCable();
      });
    });
    return Future.delayed(duration);
  }

  Widget _listaMap(BuildContext context,Map<String, dynamic> listItem, int index){
    final lp = Provider.of<ListsActionCableProvider>(context, listen: false);
    final x = Slidable(
      actionPane: SlidableDrawerActionPane(),
       actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () {
            editList(context,listItem['id'], listItem['name']);
          },
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Eliminar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            await lp.deleteList(listItem['id']);
            Fluttertoast.showToast(msg: 'Lista eliminada exitosamente', toastLength: Toast.LENGTH_LONG);
          },
        )
      ],
      child:Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Card(
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Theme.of(context).cardColor,
                margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                elevation: 5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child: ListTile(
                    /*onLongPress: (){
                      Fluttertoast.showToast(msg: 'fff', toastLength: Toast.LENGTH_LONG);
                    },*/
                    onTap: () { 
                      Navigator.pushNamed(context, 'listDetail', arguments: {'listItem': listItem, 'index': index}).then((value) {
                     if(value == null){
                       print('se mamo');
                       
                     }
                    });
                    print(listItem['id']);
                    },
                    leading: Icon(Icons.shopping_cart, color: Colors.indigo, size: 48),
                    title: Text(listItem['name'], style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
                    subtitle:  Text('Productos seleccionados: ${listItem['products'].length}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.lightBlue, size: 12,),
                  ),
                ),
              ),
                ) ,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0.0, 5.0),
                ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
              child: x,
      ),
    );
  }

  createList(BuildContext context, String error){
    final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Nueva lista', textAlign: TextAlign.center, style: Theme.of(context).textTheme.title,),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.shopping_cart, color: Colors.blue,),
                      hintText: 'Nombre de la lista',
                      labelText: 'Lista',
                    ),
                    onChanged: (t){
                      setState(() {
                        _texto = t;
                      });
                    },
                  ), 
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.add, color: Colors.white,),
                  SizedBox(width: 5,),
                  Text('Crear lista', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),),
                  SizedBox(width: 15,),
                ],),  
                onPressed: () async {
                       if(_texto.length > 0 || _texto != ''){
                         await listProvider.createList(_texto);
                         Navigator.of(context).pop();
                         controller.clear();
                         _texto = '';
                       }else{
                          Fluttertoast.showToast(msg: 'Este campo no puede ir vacío', toastLength: Toast.LENGTH_LONG);
                       }
                        
                     }
              ),
          SizedBox(width: 0,),
            FlatButton(child: Text('Cerrar'), onPressed: () { 
              Navigator.of(context).pop(); 
              controller.clear();
              },),
          ],
        );
      }, 
    );
}

editList(BuildContext context,int id, String name){
    final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);
    controller.text = name;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Editar lista', textAlign: TextAlign.center, style: Theme.of(context).textTheme.title,),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.shopping_cart, color: Colors.blue,),
                      hintText: 'Nombre de la lista',
                      labelText: 'Lista',
                    ),
                    onChanged: (t){
                      setState(() {
                        _texto = t;
                      });
                    },
                  ), 
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.mode_edit, color: Colors.white,),
                  SizedBox(width: 5,),
                  Text('Guardar', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),),
                  SizedBox(width: 15,),
                ],),  
                onPressed: () async {
                       if(_texto.length > 0 || _texto != ''){
                         await listProvider.editList(id,_texto);
                         Navigator.of(context).pop();
                         controller.clear();
                         _texto = '';
                       }else{
                          Fluttertoast.showToast(msg: 'Este campo no puede ir vacío', toastLength: Toast.LENGTH_LONG);
                       }
                        
                     }
              ),
          SizedBox(width: 0,),
            FlatButton(child: Text('Cerrar'), onPressed: () { 
              Navigator.of(context).pop(); 
              controller.clear();
              },),
          ],
        );
      }, 
    );
}

  @override
  bool get wantKeepAlive => true;
}