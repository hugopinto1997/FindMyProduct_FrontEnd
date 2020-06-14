

import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:prototipo_super_v2/src/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsProvider {

  String token;

  FriendsProvider(String t){
    token = t;
  }

Future<List<User>> allUsers() async {

    final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/users.json';

  final resp = await http.get(direccionUrl, 
  headers: {
    'authorization': token,
  });

  final decodedData = json.decode(resp.body);

  final UserModel usuarios = UserModel.fromJson(decodedData);

  //print(decodedData);
  return usuarios.users;  
}

Future<String> createFriendship(int fi) async {

    final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/users/friendships.json', 
      {
        'friend_id': fi.toString()
      }
    );

  final resp = await http.post(direccion, 
  headers: {
    'authorization': token,
  });

  final decodedData = json.decode(resp.body);

  print(decodedData['message']);
  return decodedData['message'].toString();
}

Future allFriends() async {

    final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/users/friendships.json';

  final resp = await http.get(direccionUrl, 
  headers: {
    'authorization': token,
  });

  final decodedData = json.decode(resp.body);

  print(decodedData);
  //return decodedData['message'].toString();
}

}