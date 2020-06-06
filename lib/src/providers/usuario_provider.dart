import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prototipo_super_v2/src/models/user_model.dart';


class UsuarioProvider {

  Future<Map<String, dynamic>> login(String name, String password) async {
   final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/users/login.json', 
      {
        'email': name,
        'password': password
      }
    );

    final resp = await http.post(direccion);

    Map<String, dynamic> token = json.decode(resp.body);

    print('Respuesta: ${token}');
    if(token.containsKey('Bearer')){
      return {'token': token['Bearer'], 'id': token['User_id']};
    }else{
      return {'error': token['error']};
    }
  }

 Future<Map<String, dynamic>> register(User usuario) async {
   final direccion = Uri.https(
      'findmyproduct-api.herokuapp.com',
      'api/v1/users.json', 
      {
        'user[username]': usuario.username,
        'user[password]': usuario.password,
        'user[email]': usuario.email,
        'user[phone]': usuario.phone,
      }
    );

    final resp = await http.post(direccion);

    Map<String, dynamic> token = json.decode(resp.body);

    print('Respuesta: ${token}');
    return {'resp': token};
    /*if(token.containsKey('Bearer')){
      return {'token': token['Bearer'], 'id': token['User_id']};
    }else{
      return {'error': token['error']};
    }*/
  }

}