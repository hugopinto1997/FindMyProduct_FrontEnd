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
import 'package:provider/provider.dart';
import 'package:prototipo_super_v2/src/providers/friends_provider.dart';
import 'package:prototipo_super_v2/src/models/user_model.dart';


class DataSearch extends SearchDelegate{
  BuildContext con;
  FriendsProvider fp;
  DataSearch(BuildContext ctx){
    this.con = ctx;
    fp = Provider.of(con, listen: false);
  }

@override
ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
}

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        ),
      onPressed: () {
        // Esto funciona pero solo para cerrarlo a lo bruto
        //Navigator.pop(context);

        // Ya tiene el metodo close
        close(context, null);
      });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que mostraremos
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando escribe

    if (query.isEmpty){
      return FutureBuilder(
      future: fp.allUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        
        final usuarios = snapshot.data;
        if(snapshot.hasData){
          return ListView(
            children: usuarios.map((usuario){
              return _userCard(context, usuario);
            }).toList(),
          );
        } else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );;
    }

    return FutureBuilder(
      future: fp.searchUsers(query),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        
        final usuarios = snapshot.data;
        if(snapshot.hasData){
          return ListView(
            children: usuarios.map((usuario){
              return _userCard(context, usuario);
            }).toList(),
          );
        } else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }


  Widget _userCard(BuildContext context,User u){
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
              onTap: () async { 
                final Map<String, String> r = await fp.createFriendship(u.id);
                Fluttertoast.showToast(msg: r['resp'], toastLength: Toast.LENGTH_LONG);
                 close(context, null);
                Navigator.of(context).pop();
               },
              leading: CircleAvatar(
                child: Text('${u.username[0].toUpperCase()}'),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              title: Text('${u.username}', style: Theme.of(context).textTheme.title.apply(color: Theme.of(context).textTheme.headline.color), overflow: TextOverflow.ellipsis,),
              subtitle:  Text('${u.email}', style: Theme.of(context).textTheme.subtitle.apply(color: Theme.of(context).textTheme.subhead.color)),
              trailing: Icon(Icons.group_add, color: Colors.lightBlue, size: 36,),
        ),
       ),
      ),
    );
  }

}

/*Busqueda local en el metodo Suggestions
final listaSugerida =  (query.isEmpty) ? peliculasRecientes : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i){
        return ListTile(title: Text(listaSugerida[i]),leading: Icon(Icons.movie),);
      }
      );*/