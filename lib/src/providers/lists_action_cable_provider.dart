import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:action_cable_stream/action_cable_stream.dart';
import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsActionCableProvider {
  ActionCable _cable2;
  final String _channel = "List";
  String actioncableurl = 'wss://findmyproduct-api.herokuapp.com/api/v1/cable';
  SharedPreferences prefs; 
  int userIdentifier;
  String _token;
  
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
          _cable2.performAction(_channel, 'message',
              channelParams: {'room': "private"},actionParams: {'id': userIdentifier});
        } else if (value is ActionCableMessage) {
         // final msg = json.decode(jsonEncode(value.message));
         // List<dynamic> cosa = msg["message"];
         // print('ActionCableMessage ${cosa.first}');
        }
      });
  }

  disposeCable(){
    _cable2.disconnect();
  }

  ActionCable getCable() => this._cable2;



  Future<String> createList(String name) async {
    initCable();
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

  Future<String> addProduct(int id, String name, String description, String quantity) async {
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






}