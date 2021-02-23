import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:receta/components/recipe_widget.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/receta.dart';

class MyFavoritePage extends StatefulWidget {
  ServerController _serverController;
  //User _loggedUser;

  MyFavoritePage(this._serverController);
  //MyFavoritePage(this._loggedUser);

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis favoritos", style: TextStyle(color: Colors.white)),
        ),
        body: FutureBuilder(
          future: widget._serverController
              .getFavoriteList(widget._serverController.currentUser),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Recipe> list = snapshot.data;

              if (list.length == 0) {
                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.info, size: 120, color: Colors.grey[200]),
                        Text("Su lista de favorit esta vacia. Marque algunas recetas como favorias en la pantalla de recetas.", textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                );
              }

              ///final list = widget._serverController.recipes;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Recipe recipe = list[index];
                  return RecipeWidget(
                      recipe: recipe,
                      serverController: widget._serverController,
                      onChange: () {
                        setState(() {});
                      });
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
