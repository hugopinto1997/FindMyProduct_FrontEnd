import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AddProductToListPage extends StatefulWidget {
final BuildContext ctx;
AddProductToListPage({@required this.ctx});

  @override
  _AddProductToListPageState createState() => _AddProductToListPageState();
}

class _AddProductToListPageState extends State<AddProductToListPage> {
  final formKey = GlobalKey<FormState>();
  String _descripcion, _cantidad;
  Map<String, dynamic> argumentos;
  Map<String, dynamic> _listItem;

@override
void initState() { 
  super.initState();
  final productsProvider = Provider.of<ProductsProvider>(widget.ctx);
  load(productsProvider);
}

load(ProductsProvider p) async{
  await p.getAllProducts();
}


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    argumentos = ModalRoute.of(context).settings.arguments;
    _listItem = argumentos['listItem'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Agrega un producto', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
        centerTitle: false,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}, alignment: Alignment.centerLeft,),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Expanded(child: _buildProducts(context, productsProvider)),
          ],
        ),
      ),
    );
  }

Widget _buildProducts(BuildContext context, ProductsProvider pp) {
    pp.getAllProducts();
    return FutureBuilder(
      future: pp.getAllProducts(),
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return _buildProduct(context,snapshot.data);
        } else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildProduct(BuildContext context, List products){
     return RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index){
            return _productCard(context, products[index]);
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

   Widget _productCard(BuildContext context,Map p){
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
                addProduct(context,p['name'], 'f');
               },
              leading: Icon(Icons.add_shopping_cart, color: Colors.indigo,),
              title: Text('${p['name']}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              //subtitle:  Text('${u['username']}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
              trailing: Icon(Icons.add, color: Colors.lightBlue, size: 32,),
        ),
       ),
      ),
    );
  }

void addProduct(BuildContext context,String product_name, String error){
  final size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Agregará en \'${_listItem['name']}\' el producto $product_name'),
        content: Container(
            height: size.height*0.25,
            child: productForm(context, product_name),
        ),
        actions: <Widget>[
          _createButton(context, product_name),
          FlatButton(child: Text('Cerrar'), onPressed: () => Navigator.of(context).pop(),),
        ],
      );
    }, 
  );
}

Widget productForm(BuildContext context, String name){
  return SingleChildScrollView(
      child: Column(
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              _createDescription(),
              SizedBox(height: 10,),
              _createQuantity(),
              SizedBox(height: 30,),
              //_createButton(context, name),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _createDescription(){
   return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.text,
         maxLines: 2,
         //initialValue: 'VALOR',
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

Widget _createQuantity(){
   return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.number,
         maxLines: 1,
         //initialValue: 'VALOR',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.blueAccent,
        padding: EdgeInsets.symmetric(vertical: 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Guardar cambios')
          ),
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0.0,
          //color: Colors.indigo,
          textColor: Colors.white,
          onPressed: () { _submit(context, name); },
        );
  }

  _submit(BuildContext context, String p_name) async {
    final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);

    if(formKey.currentState.validate()){
      formKey.currentState.save();
      final resp = await listProvider.addProduct(_listItem['id'], p_name , _descripcion, _cantidad);
      Fluttertoast.showToast(msg: 'Producto agregado exitosamente!', toastLength: Toast.LENGTH_LONG);
      //Navigator.popUntil(context, ModalRoute.withName('list_detail'));
      Navigator.pop(context, 'bar');
      Navigator.pop(context, 'bar');
    }

  }



}