import 'package:flutter/material.dart';


class ListDetail extends StatefulWidget {

  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  Map<String, dynamic> _listItem;

  List<String> _fotos = [
    'https://www.postconsumerbrands.com/wp-content/uploads/2019/11/Post_Hostess_Twinkies_Cereal_Box.jpg?fbclid=IwAR01YBS7woWDTmk2CZt_klrvI3NWT0c65pQAUBiTCyG2f3QLrcY9BrN_EMw',
    'https://www.nestle-centroamerica.com/sites/g/files/pydnoa521/files/asset-library/publishingimages/marcas/musun1.jpg',
    'https://static.wixstatic.com/media/32e401_840022c67be64ed68a33b34a4e9eae84~mv2.png/v1/fit/w_500,h_500,q_90/file.png',
  ];



  @override
  Widget build(BuildContext context) {
    _listItem = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _crearAppBar(_listItem),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  SizedBox(height: 8.0,),
                  _posterTitulo(context, _listItem),
                  SizedBox(height: 10.0,),

                  _crearLista2(context, 'Producto', _fotos[0]) ,  
                  _crearLista2(context, 'Producto', _fotos[0]) ,
                  _crearLista2(context, 'Producto', _fotos[0]) ,  
                  _crearLista2(context, 'Producto', _fotos[0]) ,  
                                            
                ]
              ),
              )
          ],
          ),
    );
  }


  Widget _crearAppBar(Map<String, dynamic> listItem){
      return SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.blueGrey,
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
            image: NetworkImage('https://cdn-ep19.pressidium.com/wp-content/uploads/2018/10/photoshop-collage-muang-mai-markets.jpg')),
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
                      (listItem['quantity'] != null) ? '${listItem['quantity']} artículos seleccionados' : '0 artículos seleccionados', 
                      style: TextStyle(fontSize: 16),
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
                     height: 125.0, width:90,
                    ),
                ),
              SizedBox(width: 20.0,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(nombre,
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



}