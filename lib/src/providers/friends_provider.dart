

import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:prototipo_super_v2/src/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsProvider {

  String token;

  FriendsProvider(String t){
    token = t;
  }



setPrefs(String t){
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

Future<Map<String, String>> createFriendship(int fi) async {

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
  return {'resp': decodedData['message'].toString()};
}

Future<List> allFriends() async {

    final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/users/friendships.json';

  final resp = await http.get(direccionUrl, 
  headers: {
    'authorization': token,
  });

  List friends = new List();

  final decodedData = json.decode(resp.body);

   friends.addAll(decodedData['friends']);
   friends.addAll(decodedData['inverse_friends']);

  //print(friends[0]['username']);
  return friends;
}

Future<List> friendRequests() async {

    final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/users/friendships.json';

  final resp = await http.get(direccionUrl, 
  headers: {
    'authorization': token,
  });

  List friends = new List();

  final decodedData = json.decode(resp.body);

   friends.addAll(decodedData['friend_requests']);

  //print(friends[0]['username']);
  return friends;
}

Future<String> acceptRequest(String rid, String uid) async {
final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/users/friendships/$rid.json', 
      {
        'friend_id': uid
      }
    );


  final resp = await http.patch(direccion, 
  headers: {
    'authorization': token,
  });

  final decodedData = json.decode(resp.body);

  //print(friends[0]['username']);
  return decodedData['message'].toString();
}


Future<String> deleteRequest(String rid) async {

   final direccionUrl = 'https://findmyproduct-api.herokuapp.com/api/v1/users/friendships/$rid.json';

  final resp = await http.delete(direccionUrl, 
  headers: {
    'authorization': token,
  });

  final decodedData = json.decode(resp.body);

  //print(friends[0]['username' ]);
  return decodedData['message'].toString();
}




}