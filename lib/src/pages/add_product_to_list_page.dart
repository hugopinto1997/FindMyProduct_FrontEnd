import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AddProductToListPage extends StatefulWidget {
final BuildContext ctx;
AddProductToListPage({@required this.ctx});

  @override
  _AddProductToListPageState createState() => _AddProductToListPageState();
}

class _AddProductToListPageState extends State<AddProductToListPage> {

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
    final pp = Provider.of<ProductsProvider>(context);
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
              leading: Icon(Icons.add_shopping_cart, color: Colors.indigo,),
              title: Text('${p['name']}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              //subtitle:  Text('${u['username']}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
              trailing: Icon(Icons.add, color: Colors.lightBlue, size: 32,),
        ),
       ),
      ),
    );
  }



}