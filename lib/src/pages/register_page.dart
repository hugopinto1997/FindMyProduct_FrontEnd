import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final formKey = GlobalKey<FormState>();
  final passKey = GlobalKey<FormFieldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regístrate a FindMyProduct'),
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
          onPressed: () { _submit(); },
        );
  }


void _submit(){
  if( formKey.currentState.validate() ){
    Fluttertoast.showToast(msg: 'valido', toastLength: Toast.LENGTH_LONG);
  }else{
     Fluttertoast.showToast(msg: 'NEL', toastLength: Toast.LENGTH_LONG);
  }
}

}