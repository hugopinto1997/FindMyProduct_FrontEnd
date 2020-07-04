import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:action_cable_stream/action_cable_stream.dart';
import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsActionCableProvider with ChangeNotifier {
  ActionCable _cable2;
  final String _channel = "List";
  String actioncableurl = 'wss://findmyproduct-api.herokuapp.com/api/v1/cable';
  SharedPreferences prefs; 
  int userIdentifier;
  String _token;
  List<dynamic> listas = [];
  bool peticion = true;
  int contador = 0;
  
  ListsActionCableProvider(int ui, String tk){
    userIdentifier = ui;
    _token = tk;
    initCable();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userIdentifier = prefs.getInt("id");
  }

  setToken(String t, int isd){
    _token = t;
    userIdentifier = isd;
  }

  initCable(){
    initPrefs();
    _cable2 = ActionCable.Stream(actioncableurl);
    _cable2.stream.listen((value) {
        if (value is ActionCableConnected) {
          _cable2.subscribeToChannel(_channel, channelParams: {'room': "private"});
         print('ActionCableConnected');
        } else if (value is ActionCableSubscriptionConfirmed) {
          print('ActionCableSubscriptionConfirmed');
          //this.getUserLists();
          //notifyListeners();
          _cable2.performAction(_channel, 'message',
              channelParams: {'room': "private"}, actionParams: {'id': userIdentifier});
        } else if (value is ActionCableMessage) {
         // final msg = json.decode(jsonEncode(value.message));
         // List<dynamic> cosa = msg["message"];
         // print('ActionCableMessage ${cosa.first}');
        }
      });
  }

  void update() {  _cable2.performAction(_channel, 'message',
              channelParams: {'room': "private"},actionParams: {'id': userIdentifier});
  }

  disposeCable(){
    _cable2.disconnect();
  }

  ActionCable getCable() => this._cable2;



  Future<String> createList(String name) async {
     // initCable();
      final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/lists.json', 
      {
        'list[name]': name
      }
    );

    final resp = await http.post(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData['message'].toString();
  }

Future deleteList(int listId) async {
      final direccion = 'https://findmyproduct-api.herokuapp.com/api/v1/lists/$listId.json';

    final resp = await http.delete(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData.toString());
  }

  Future<String> addProduct(int id, String name, String description, String quantity) async {
      //initCable();
      final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/listproducts/add.json', 
      {
        'id': id.toString(),
        'name': name,
        'description': description,
        'quantity': quantity
      }
    );

    final resp = await http.post(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData['message'].toString();
  }

  Future<String> editProduct(int id, String name, String description, String quantity) async {
      final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/listproducts/$id.json', 
      {
        'name': name,
        'quantity': quantity,
        'description': description
      }
    );

    final resp = await http.patch(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData['message'].toString();
  }



Future<String> deleteProduct(int id, String name) async {
      //initCable();
      final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/listproducts/$id.json', 
      {
        'id': id.toString(),
        'name': name,
      }
    );

    final resp = await http.delete(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData['message'].toString();
  }


Future<String> addFriend(int id, String name) async {
      final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/listusers/add', 
      {
        'id': id.toString(),
        'name': name
      }
    );

    final resp = await http.post(direccion, 
    headers: {
      'Authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData.toString();
  }

Future getUserLists() async {
      final direccion = 'https://findmyproduct-api.herokuapp.com/api/v1/users/$userIdentifier/lists.json';

     // if(peticion == false){
      //  peticion = true;
        final resp = await http.get(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    this.listas = [];
    print('cargando... $contador');
    this.listas.addAll(decodedData['info']);
    contador++;
   // notifyListeners();
      /*}else{
        peticion = false;
      }*/
    //print(decodedData);
    /*if(peticion){
      print('verdad');
      peticion = false;
      //notifyListeners();
    }else{
      print('falso');
      peticion = true;
    }*/
  }
  getBroadcastUserLists() async {
      final direccion = 'https://findmyproduct-api.herokuapp.com/api/v1/users/$userIdentifier/lists.json';

     // if(peticion == false){
      //  peticion = true;
        final resp = await http.get(direccion, 
    headers: {
      'authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    this.listas = [];
    print('por el action cable...');
    this.listas.addAll(decodedData['info']);
    //notifyListeners();
      /*}else{
        peticion = false;
      }*/
    //print(decodedData);
    /*if(peticion){
      print('verdad');
      peticion = false;
      //notifyListeners();
    }else{
      print('falso');
      peticion = true;
    }*/
  }


Future<List> listFriends(int list_id) async {

    final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/lists/$list_id/users.json';

  final resp = await http.get(direccionUrl, 
  headers: {
    'authorization': _token,
  });

  List usuarios = new List();

  final decodedData = json.decode(resp.body);

  usuarios.addAll(decodedData['users']);

  print(decodedData['users']);
  return usuarios;
}


Future<String> deleteFriendFromList(int list, String username) async {
      final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/listusers/$list', 
      {
        'name': username
      }
    );

    final resp = await http.delete(direccion, 
    headers: {
      'Authorization': _token,
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return decodedData.toString();
  }

}