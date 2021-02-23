import 'package:flutter/material.dart';
import 'package:receta/conections/server_controller.dart';

class MyDrawer extends StatelessWidget {
  final ServerController _serverController;

  MyDrawer(this._serverController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: <Widget>[
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        )),
        accountName: Text(
          _serverController.currentUser.username,
          style: TextStyle(color: Colors.white),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: AssetImage(_serverController.currentUser.photo),
        ),
        onDetailsPressed: () {
          Navigator.pop(context);
          Navigator.of(context)
              .pushNamed('/register', arguments: _serverController.currentUser);
        },
      ),
      ListTile(
        title: Text(
          "Mis recetas",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: Icon(
          Icons.book,
          color: Colors.lightGreenAccent,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).pushNamed('/user_recipes');
        },
      ),
      ListTile(
        title: Text(
          "Mis favoritos",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).pushNamed('/favorites');
        },
      ),
      ListTile(
        title: Text(
          "Cerrar sesión",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: Icon(
          Icons.power_settings_new,
          color: Colors.cyan,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, "/");
        },
      )
    ]));
  }
}
