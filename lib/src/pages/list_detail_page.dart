import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';


class ListDetail extends StatefulWidget {
final BuildContext ctx;
ListDetail({@required this.ctx});
  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail>{
   final formKey = GlobalKey<FormState>();
  String _descripcion, _cantidad;
  Map<String, dynamic> _listItem;
  Map<String, dynamic> argumentos;
  int identificador;
  ListsActionCableProvider _productsCable;
  ListsActionCableProvider _productsCable2;
  int cantidadProductos, _participantes = 1;
  StateSetter _estadoModal;
  bool ref = false;


  

  @override
  void initState() { 
    super.initState();
    _productsCable = Provider.of<ListsActionCableProvider>(widget.ctx);
    _productsCable.initCable();
  }

  _initParticipantes(int id) async {
    List usuarios = await _productsCable.listFriends(id);
    _participantes = usuarios.length;
    if(ref == false){
      setState(() {
      
      });
      ref = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
     _productsCable.disposeCable();
  }


  @override
  Widget build(BuildContext context) {
    argumentos = ModalRoute.of(context).settings.arguments;
    _listItem = argumentos['listItem'];
    _productsCable2 = Provider.of<ListsActionCableProvider>(context, listen: false);
    _initParticipantes(_listItem['id']);
    //print(identificador);
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBool){
            return <Widget>[
              _crearAppBar(_listItem),
            ];
          }, 
          body: Column(
            children: <Widget>[
              SizedBox(height: 8.0,),
              _posterTitulo(context, _listItem),
               Flexible(
                 child: 
                   StreamBuilder(
                    stream: _productsCable.getCable().stream,
                    initialData: ActionCableInitial(),
                    builder: (context, AsyncSnapshot<ActionCableDataState> snapshot){
                    if(snapshot.hasData){
                      return buildBody(snapshot, context);
                    }else{
                      return NoData(Icons.add_shopping_cart, 'Algo sucedió, prueba en otro momento');
                    }
                  },
                 ),
               )
            ],
          ), 
       ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'boton_agregar',
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
        onPressed: () { 
         Navigator.pushNamed(context, 'add_product', arguments: {'listItem': _listItem}).then((value) { 
         
         
         });
        }),
    );
  }


  Widget _crearAppBar(Map<String, dynamic> listItem){
      return SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.indigo ,
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.people), onPressed: () {
            editList(context);
          },),
        ],
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background: FadeInImage(
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage('https://images.theconversation.com/files/223713/original/file-20180619-38837-1t04rux.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=496&fit=clip')),
          title: Text(
            '${listItem['name']}',
            overflow: TextOverflow.ellipsis,maxLines: 1,
            style: TextStyle(fontSize: 16.0,
           ),
          ),
          titlePadding: EdgeInsets.only(right: 80, left:80, bottom:15),
        ),
      );
  }

  Widget _posterTitulo(BuildContext context, Map<String, dynamic> listItem){
     _initParticipantes(_listItem['id']);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage('https://previews.123rf.com/images/val2014/val20141603/val2014160300006/54302308-shopping-cart-icon.jpg'),
                 height: 80.0,
                ),
            ),
          SizedBox(width: 20.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text((listItem['name'] != null) ? '${listItem['name']}' : 'No disponible',
                style: Theme.of(context).textTheme.title,),
                 Text('Creada el: ${listItem['creation'].toString().substring(0,10)} ',
                 overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle,),

                Text('$_participantes Participantes',
                 overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subhead,),

                Row(
                  children: <Widget>[
                    Icon(Icons.add_shopping_cart, size: 25,),
                    SizedBox(width: 2,height:20),
                    Text(
                      'Lista de artículos', 
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                      )
                  ],
                  ),
              ],),
          ),
        ],
      ),
    );
  }

  Widget _crearLista2(BuildContext context, String nombre, String imagen){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          elevation: 5.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
              child: _posterTitulo2(context,nombre, imagen),
          ),
       ),
    );
  }

  Widget _posterTitulo2(BuildContext context,String nombre, String imagen){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(imagen),
                     height: 100.0, width:90,
                    ),
                ),
              SizedBox(width: 25.0,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text((nombre == null) ? '' : nombre ,
                    style: Theme.of(context).textTheme.title.apply(color: Colors.white),),
                     Text('Cantidad: 1',
                     overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle),

                    Text('Descripción: De este solo traiga el del paquete que trae los 2 grandes',
                     overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subhead,),
                                   
                  ],

                  ),
              ),
            ],
          ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),        
                        child: FlatButton(onPressed: () { }, 
                        child: Text('Quitar', style: TextStyle(color: Colors.white),),
                        color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                     Expanded(
                         child: ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: FlatButton(
                           onPressed: () { }, 
                    child: Text('Comprado', style: TextStyle(color: Colors.white),),
                    color: Colors.greenAccent,
                    ),
                       ),
                     )
                  ],
                  ),
        ],
      ),
    );
  }


void editList(BuildContext context){
  final fp = Provider.of<ListsActionCableProvider>(context, listen: false);
  final size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Agrega en \'${_listItem['name']}\' los amigos que podrán participar'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            _estadoModal = setState;
            return Container(
            height: size.height*0.35,
            width: size.width,
            child: Column(
            children: <Widget>[
              Expanded(child: _buildFriends(context, fp)),
            ],
          ),
        );
          }, 
        
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
                  Text('Agregar amigo', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),),
                  SizedBox(width: 15,),
                ],),  
                onPressed: (){ 
                   Navigator.pushNamed(context, 'add_list_friend', arguments: {'listItem': _listItem}).then((value) { setState(() {
           
         });});
                }
              ),
          SizedBox(width: 0,),
          FlatButton(child: Text('Cerrar'), onPressed: () => Navigator.of(context).pop(),)
        ],
      );
    }, 
  );
}

Widget _buildFriends(BuildContext context, ListsActionCableProvider fp) {
      fp.listFriends(_listItem['id']);
    return FutureBuilder(
      future: fp.listFriends(_listItem['id']),
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
          onRefresh: refresh4,
          child: ListView.builder(
          itemCount: usrs.length,
          itemBuilder: (context, index){
            return _userCard(context, usrs[index]);
          },
        ),
     );
  }

  Future<Null> refresh4() async {
    final duration = new Duration(
      seconds: 1
    );
    Timer(duration, (){
      _estadoModal(() {
        _productsCable.listFriends(_listItem['id']);
      });
      setState(() {
                _productsCable.listFriends(_listItem['id']);

      });
    });
    return Future.delayed(duration);
  }

  Widget _userCard(BuildContext context,Map u){
    final fp = Provider.of<ListsActionCableProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Theme.of(context).cardColor,
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          elevation: 5.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
              child: ListTile(
              leading: CircleAvatar(
                child: Text('${u['username'][0].toString().toUpperCase()}'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              title: Text('${u['username']}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              trailing: IconButton(icon: Icon(Icons.delete, color: Colors.deepOrange,),onPressed: () {
                deleteUser(fp, u);
                /*_estadoModal(() {
                  fp.listFriends(_listItem['id']);
                });*/
              },),
        ),
       ),
      ),
    );
  }

  deleteUser(ListsActionCableProvider fp, Map<String, dynamic> u) async {
    final resp = await fp.deleteFriendFromList(_listItem['id'], u['username']);
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
             print('vine aqui LIST DETAIL...');
            
         final ej = json.decode(jsonEncode(state.message));
       final res = json.decode(ej['message'])['info'];
       final r = filterByUser(res, _productsCable);

      List products = listInfo(r);
       
          return RefreshIndicator(
             onRefresh: refresh2,
             child: ListView.builder(
             itemCount: products.length ?? 0,
             itemBuilder: (context, index){
               return _buildListItem(context, products[index]);
             },
         ),
        );
        //return Text('${products}');
      //}
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

List listInfo(List lista){
  Map selected_list;
  lista.forEach((element) {
    Map<String, dynamic> e = element;
      if(e['id'] == _listItem['id']){
        selected_list = e;
      }
   });
   return selected_list['products'];
}

cargarCosas(ListsActionCableProvider p) async {
  await p.getUserLists();
}

Future<Null> refresh2() async {
    final duration = new Duration(
      seconds: 1
    );
    Timer(duration, (){
      setState(() {
        _productsCable2.initCable();
      });
    });
    return Future.delayed(duration);
  }







Widget _buildSlidableItem(BuildContext context,Map<String, dynamic> product){
  final productsProvider = Provider.of<ProductsProvider>(context);
  final listp = Provider.of<ListsActionCableProvider>(context);
  final lp = Provider.of<ListsActionCableProvider>(context);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.green,
          icon: Icons.edit,
          onTap: ()  {
          addProduct(context, '${product['product_name']}','${product['product_descripcion']}', '${product['product_quantity']}');
          },
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Eliminar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            final d = await lp.deleteProduct(_listItem['id'], product['product_name']);
            Fluttertoast.showToast(msg: 'Producto eliminado', toastLength: Toast.LENGTH_LONG);
          },
        )
      ],
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        elevation: 10.0,
        child: CheckboxListTile(
          activeColor: Colors.green,
          secondary: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Cant.', style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16),),
              SizedBox(height: 0,),
              Text('${product['product_quantity']}', style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 20),),
          ],),
          title: Text('${product['product_name']}', style: Theme.of(context).textTheme.title,),
          subtitle: (product['product_descripcion'] == null) ? Text('Sin descripción', style: Theme.of(context).textTheme.subtitle1,) : Text('${product['product_descripcion']}',  style: Theme.of(context).textTheme.subtitle1,),
          value: (product['product_status'] != false) ? true : product['product_status'],
          onChanged: (newValue) async {
            final r = await productsProvider.setCheck(_listItem['id'].toString(), product['product_name']);
           
        },
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Map<String, dynamic> product) {
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
              child: _buildSlidableItem(context,product) ,
      ),
    );
  }




void addProduct(BuildContext context,String product_name, String description, String quantity){
  final size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Editará de \'${_listItem['name']}\' el producto $product_name'),
        content: SingleChildScrollView(
                  child: Container(
              height: size.height*0.35,
              child: productForm(context, product_name, description, quantity),
          ),
        ),
        actions: <Widget>[
          FlatButton(child: Text('Cerrar'), onPressed: () => Navigator.of(context).pop(),),
        ],
      );
    }, 
  );
}

Widget productForm(BuildContext context, String name, String description, String quantity){
  return Column(
    children: <Widget>[
      Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            _createDescription(description),
            SizedBox(height: 10,),
            _createQuantity(quantity),
            SizedBox(height: 30,),
            _createButton(context, name),
          ],
        ),
      ),
    ],
  );
}

Widget _createDescription(String desc){
   return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.text,
         maxLines: 2,
         initialValue: desc,
         decoration: InputDecoration(
         icon: Icon(Icons.description, color: Colors.blue,),
         hintText: 'Descripción',
         labelText: 'Descripción del producto',
          //counterText: snapshot.data,
          //errorText: snapshot.error,
            ),
         onSaved: (d) => _descripcion = d,
         validator: (value){
            if (value.length == 0) { return 'La descripción no puede ir vacía'; 
            }else { return null; }
         },
          ),
        );
}

Widget _createQuantity(String q){
   return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.number,
         maxLines: 1,
         initialValue: q,
         decoration: InputDecoration(
         icon: Icon(Icons.add_to_photos, color: Colors.blue,),
         hintText: 'Cantidad',
         labelText: 'Cantidad del producto',
          //counterText: snapshot.data,
          //errorText: snapshot.error,
            ),
         onSaved: (c) => _cantidad = c,
         validator: (value){
            if (value.length == 0) { return 'La cantidad no puede ir vacía'; 
            }else if(value == '0'){
              return 'La cantidad no puede ser 0';
            }
            else { return null; }
         },
          ),
        );
}

Widget _createButton(BuildContext context, String name){

     return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text('Guardar cambios')
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0.0,
          color: Colors.indigo,
          textColor: Colors.white,
          onPressed: () { _submit(context, name); },
        );
  }

  _submit(BuildContext context, String p_name) async {
    final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);

    if(formKey.currentState.validate()){
      formKey.currentState.save();
      final r = await listProvider.editProduct(_listItem['id'], p_name, _descripcion, _cantidad);
      
      Navigator.pop(context);
    }

  }


}

