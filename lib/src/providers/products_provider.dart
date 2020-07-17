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

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsProvider{
  int _loggedUser;
  String _token;

  ProductsProvider(int u, String t){
    _loggedUser = u;
    _token = t;
  }

  setData(int u, String t){
    _loggedUser = u;
    _token = t;
  }


  Future<List> getAllProducts() async {
    final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/products.json';

  final resp = await http.get(direccionUrl, 
  headers: {
    'authorization': _token,
  });

  List products = new List();

  final decodedData = json.decode(resp.body);

  products.addAll(decodedData['products']);

 // print(products);
  return products;
  }

Future<List> searchProducts(String query) async {

   final direccionUrl = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/products/search.json', 
      {
        'filter': query
      }
    );

  final resp = await http.get(direccionUrl, 
  headers: {
    'Authorization': _token,
  });

  dynamic decodedData;
  List p = new List();

    if(resp.body.isNotEmpty){
      decodedData = json.decode(resp.body);
      p.addAll(decodedData['product']);
      print(decodedData);
    }else{
      decodedData = json.decode(resp.body);
      p.add(decodedData['product']);
      print('Null data...');
    }
    
    return p;  

  
}


  Future<String> setCheck(String id, String name) async {
    final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/listproducts/check.json', 
      {
        'id': id,
        'name': name,
      }
    );

  final resp = await http.post(direccion, 
  headers: {
    'authorization': _token,
  });

  //List products = new List();

  final decodedData = json.decode(resp.body);

  //products.addAll(decodedData['products']);

  //print(products);
  return decodedData.toString();
  }



}