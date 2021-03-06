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

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/bloc/login_bloc.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
import 'package:prototipo_super_v2/src/providers/usuario_provider.dart';
import 'package:prototipo_super_v2/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

Widget _crearFondo(BuildContext context){
  final size = MediaQuery.of(context).size;

  final fondoSuperior = Container(
    height: size.height*0.4,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color.fromRGBO(6, 66, 186, 1.0),
          Color.fromRGBO(56, 114, 232, 1.0),
        ],
        ),
    ),
  );

   final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.white10,
      ),
    );

    return Stack(
      children: <Widget>[
        fondoSuperior,
         Positioned(top: 90, left: 30, child: circulo),
        Positioned(top: -40, right: -30, child: circulo),
        Positioned(bottom: -50, right: -10, child: circulo),

        Container(
          padding: EdgeInsets.only(top: 80,),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin, color: Colors.white, size: 100),
              SizedBox(height: 10, width: double.infinity,),
              Text('Inicie sesión', style: TextStyle(color: Colors.white, fontSize: 32),),
            ],
          ),
        ),
      ],
    );

}

Widget _loginForm(BuildContext context){
    
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of<LoginBloc>(context);
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(child: Container(height: 200)),

          Container(
            width: size.width*0.8,
            padding: EdgeInsets.symmetric(vertical: 20),
            margin: EdgeInsets.symmetric(vertical:30),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 3,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[

                Text('Ingrese sus credenciales', style: TextStyle(fontSize: 20, ),),

                SizedBox(height: 60,),

                _crearEmail(bloc),
                SizedBox(height: 20),
                _crearPassword(bloc),
                SizedBox(height: 20),
                _crearBoton(bloc, context),
                SizedBox(height: 10),
                Text('¿No tienes una cuenta?'),
                SizedBox(height: 5),
                _crearBotonRegister(bloc, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
               icon: Icon(Icons.mail, color: Colors.blue,),
               hintText: 'example@example.com',
               labelText: 'Correo electrónico',
               //counterText: snapshot.data,
               errorText: snapshot.error,
            ),
            onChanged: (value){
              bloc.changeEmail(value);
            },
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream,
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock , color: Colors.blue,),
          hintText: 'Password',
          labelText: 'Contraseña',
          counterText: snapshot.data,
          errorText: snapshot.error,
        ),
        onChanged: (value){
          bloc.changePassword(value);
        },
      ),
    );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, BuildContext context){

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
            return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
            child: Text('Entrar')
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0.0,
          color: Color.fromRGBO(6, 66, 186, 1.0),
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  Widget _crearBotonRegister(LoginBloc bloc, BuildContext context){

     return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
            child: Text('Registrate')
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, 'register'),
        );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    final usuarioProvider = new UsuarioProvider();
    final friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
    final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);
    final productsProvider = Provider.of<ProductsProvider>(context,listen: false);
    final prefs = await SharedPreferences.getInstance();
    //print("Email: ");
    final Map<String, dynamic> entra = await usuarioProvider.login(bloc.email, bloc.password);
    if(entra.containsKey('token')){
      Navigator.pushReplacementNamed(context, 'home');
      prefs.setString('token', entra['token']);
      prefs.setInt('id', entra['id']);
      friendsProvider.setPrefs(entra['token']);
      listProvider.setToken(entra['token'], entra['id']);
      productsProvider.setData(entra['id'], entra['token']);
      Fluttertoast.showToast(msg: 'Iniciando sesión...', toastLength: Toast.LENGTH_LONG);
    }else{
      showModal(context, entra['error']);
    }
  }

}