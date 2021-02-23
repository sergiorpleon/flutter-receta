import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:receta/components/my_drawer.dart';
import 'package:receta/components/recipe_widget.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/receta.dart';
import 'package:receta/models/user.dart';

class HomePage extends StatefulWidget {
  ServerController _serverController;
  //User _loggedUser;

  HomePage(this._serverController);
  //HomePage(this._loggedUser);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Cookbook", style: TextStyle(color: Colors.white)),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'uno',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/edit_recipe");
          },
        ),
        drawer: MyDrawer(widget._serverController),
        body: FutureBuilder(
          future: widget._serverController.getRecipeList(),
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
                        Text(
                          "No exiten recetas de recetas. Crea una!!!",
                          textAlign: TextAlign.center,
                        )
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
