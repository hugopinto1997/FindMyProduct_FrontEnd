import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prototipo_super_v2/src/models/user_model.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/providers/lists_action_cable_provider.dart';
import 'package:prototipo_super_v2/src/providers/products_provider.dart';
import 'package:prototipo_super_v2/src/providers/usuario_provider.dart';
import 'package:prototipo_super_v2/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final formKey = GlobalKey<FormState>();
  final passKey = GlobalKey<FormFieldState>();
  User _usuario = new User();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regístrate'),
      ),
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _registerForm(context),
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
          Colors.indigo,
          Colors.blueGrey,
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
              Icon(Icons.person_add, color: Colors.white, size: 100),
              SizedBox(height: 10, width: double.infinity,),
              Text('Regístrate', style: TextStyle(color: Colors.white, fontSize: 32),),
            ],
          ),
        ),
      ],
    );

}

Widget _registerForm(BuildContext context){
    
    final size = MediaQuery.of(context).size;
    //final bloc = Provider.of<LoginBloc>(context);
    
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(child: Container(height: 220)),

          Container(
            width: size.width*0.8,
            padding: EdgeInsets.symmetric(vertical: 20,),
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

                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                    SizedBox(height: 10,),
                    _crearUsername(),
                    SizedBox(height: 10,),
                    _crearEmail(),
                    SizedBox(height: 10),
                    _crearPassword(),
                    SizedBox(height: 10),
                    _crearConfirmarPassword(),
                    SizedBox(height: 10),
                    _crearTelefono(),
                    SizedBox(height: 10),
                    _crearBotonRegister(context),

                   // _crearTelefono(),
                  ],),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _crearUsername(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.text,
         decoration: InputDecoration(
         icon: Icon(Icons.person_pin, color: Colors.blue,),
         hintText: 'username',
         labelText: 'Nombre de Usuario',
          //counterText: snapshot.data,
          //errorText: snapshot.error,
            ),
         onSaved: (u) => _usuario.username = u,
         validator: (value){
            if (value.length == 0) { return 'Nombre de Usuario no puede ir vacío'; 
            }else { return null; }
         },
          ),
        );
}

Widget _crearEmail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.emailAddress,
         decoration: InputDecoration(
         icon: Icon(Icons.mail, color: Colors.blue,),
         hintText: 'example@example.com',
         labelText: 'Correo electrónico',
          //counterText: snapshot.data,
          //errorText: snapshot.error,
            ),
           onSaved: (email) => _usuario.email = email,
           validator: (correo) {
             final bool correoValido = EmailValidator.validate(correo); 
             if(correo.length == 0){
               return 'El correo electrónico es requerido';
             } else if (!correoValido){
               return 'Formato de correo electrónico inválido';     
             }else{
               return null;
             }
           },
          ),
        );
}

Widget _crearPassword(){
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         key: passKey,
         obscureText: true,
         decoration: InputDecoration(
         icon: Icon(Icons.lock, color: Colors.blue,),
         hintText: 'Contraseña',
         labelText: 'Contraseña',
         counterText: 'Al menos 6 caracteres',
       ),
       validator: (pass){
          if(pass.length == 0){
            return 'La contraseña es requerida';
          }else if (pass.length < 6){
            return 'Debe tener 6 caracteres o más';
          }else{
            return null;
          }
       },
      ),
    );
}

Widget _crearConfirmarPassword(){
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         obscureText: true,
         decoration: InputDecoration(
         icon: Icon(Icons.lock, color: Colors.blue,),
         hintText: 'Contraseña',
         labelText: 'Confirmar contraseña',
         counterText: 'Al menos 6 caracteres',
       ),
       onSaved: (pass) => _usuario.password = pass,
       validator: (pass){
         var contrasena = passKey.currentState.value;
         if(pass.length == 0){
            return 'La contraseña es requerida';
          }else if (pass.length < 6){
            return 'Debe tener 6 caracteres o más';
          }else if( contrasena != pass ){
            return 'Las contraseñas no coinciden';
          }
          else{
            return null;
          }
       },
      ),
    );
}

Widget _crearTelefono(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
       child: TextFormField(
         keyboardType: TextInputType.phone,
         maxLength: 8,
         decoration: InputDecoration(
         icon: Icon(Icons.phone_android, color: Colors.blue,),
         hintText: '70000000',
         labelText: 'Teléfono celular',
        ),
      onSaved: (phone) => _usuario.phone = phone.toString(),  
      validator: (telefono){
              String pattern = r'(^([6-7]{1})?[0-9]{7}$)';
              RegExp r = new RegExp(pattern);
              if(telefono.length == 0){
                return 'El teléfono es requerido';
              }else if (!r.hasMatch(telefono)){
                return 'Teléfono inválido';
              }else{
                return null;
              }
            },
          ),
        );
}

Widget _crearBotonRegister(BuildContext context){

     return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
            child: Text('Registrate')
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0.0,
          color: Colors.indigo,
          textColor: Colors.white,
          onPressed: () { _submit(context); },
        );
  }


void _submit(BuildContext context) async {
    final usuarioProvider = new UsuarioProvider();
    final prefs = await SharedPreferences.getInstance();
    final friendsProvider = Provider.of<FriendsProvider>(context, listen: false);
    final listProvider = Provider.of<ListsActionCableProvider>(context, listen: false);
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

  if( formKey.currentState.validate() ){
    formKey.currentState.save();
    final Map<String, dynamic> entra = await usuarioProvider.register(_usuario);
    final Map<String,dynamic> resp = entra['resp'];
    //Si entra aqui si hace login
    if(resp.containsKey('status')){
       final Map<String, dynamic> entra2 = await usuarioProvider.login(_usuario.email, _usuario.password);
    if(entra2.containsKey('token')){
      prefs.setString('token', entra2['token']);
      prefs.setInt('id', entra2['id']);
      friendsProvider.setPrefs(entra2['token']);
      listProvider.setToken(entra2['token'], entra2['id']);
      productsProvider.setData(entra2['id'], entra2['token']);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, 'home');
    Fluttertoast.showToast(msg: '${entra['resp']['status']}', toastLength: Toast.LENGTH_LONG);
    }else{
      showModal(context, entra['error']);
    }
  }else{
    final Map<String, dynamic> entra = await usuarioProvider.register(_usuario);
    final Map<String,dynamic> resp = entra['resp'];
    showModal(context, '${resp['errors']}');
  }
     //Navigator.pushReplacementNamed(context, 'home');
     // prefs.setString('token', entra['token']);
    //  prefs.setInt('id', entra['id']);
  }
}

}

