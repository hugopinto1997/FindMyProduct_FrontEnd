import 'dart:convert';

import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';


class ListDetail extends StatefulWidget {
final BuildContext ctx;
ListDetail({@required this.ctx});
  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> with KeepAliveParentDataMixin{
  Map<String, dynamic> _listItem;
  Map<String, dynamic> argumentos;
  int identificador;
  ListsActionCableProvider _productsCable;
  int cantidadProductos;


  List<String> _fotos = [
    'https://www.postconsumerbrands.com/wp-content/uploads/2019/11/Post_Hostess_Twinkies_Cereal_Box.jpg?fbclid=IwAR01YBS7woWDTmk2CZt_klrvI3NWT0c65pQAUBiTCyG2f3QLrcY9BrN_EMw',
    'https://www.nestle-centroamerica.com/sites/g/files/pydnoa521/files/asset-library/publishingimages/marcas/musun1.jpg',
    'https://static.wixstatic.com/media/32e401_840022c67be64ed68a33b34a4e9eae84~mv2.png/v1/fit/w_500,h_500,q_90/file.png',
  ];


  @override
  void initState() { 
    super.initState();
    _productsCable = Provider.of<ListsActionCableProvider>(widget.ctx);
    _productsCable.initCable();
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
    identificador = argumentos['index'];
    print(identificador);
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
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
        onPressed: (){ }),
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
          IconButton(icon: Icon(Icons.mode_edit), onPressed: () {},),
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
                 Text('Creada por: Nombre de Usuario',
                 overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle,),

                Text('4 Participantes',
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
       List<dynamic> productos = res[identificador]['products'];
      cantidadProductos = productos.length;
      if(cantidadProductos == 0){
        return NoData(Icons.add_shopping_cart, 'Aún no tienes ningún producto en esta lista');
      }else{
        return ListView.builder(
           itemCount: productos.length ?? 0,
           itemBuilder: (context, index){
             return _crearLista2(context, productos[index]['product_name'].toString() , _fotos[0]);
           },
         );
      }
      //return Text('${productos.length}');
    } else if (state is ActionCableDisconnected) {
      return Text('Disconnected');
    } else {
      return Text('Something went wrong');
    }
  }

  @override
  void detach() {
  }

  @override
  bool get keptAlive => true;



}