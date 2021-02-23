import 'package:flutter/material.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/receta.dart';
import 'package:receta/models/user.dart';

typedef OnChange = Function();

class RecipeWidget extends StatefulWidget {
  final ServerController serverController;
  final Recipe recipe;
  final OnChange onChange;

  RecipeWidget(
      {@required this.recipe,
      @required this.serverController,
      @required this.onChange});

  @override
  _RecipeWidgetState createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: GestureDetector(
        onTap: () {
          _showDetail(context, widget.recipe);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Card(
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.recipe.image),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.black.withOpacity(0.35),
                child: ListTile(
                  title: Text(
                    widget.recipe.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    widget.recipe.user.username,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: _loading
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 5,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: _isFavorite(widget.recipe)
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.favorite_border_outlined,
                                    color: Colors.white),
                            onPressed: () {
                              _pressFavorite(widget.recipe,
                                  widget.serverController.currentUser);
                            },
                            iconSize: 32,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isFavorite(Recipe recipe) {
    User currentuser = widget.serverController.currentUser;
    if (recipe != null && recipe.userlikes != null) {
      for (var userid in recipe.userlikes) {
        if (userid == currentuser.id) {
          return true;
        }
      }
    }
    return false;
  }

  void _pressFavorite(Recipe recipe, User currentUser) async {
    setState(() {
      _loading = true;
    });
    print("object updte true");
    print(_loading);
    await widget.serverController.updateFavorite(recipe, currentUser);
    setState(() {
      _loading = false;
    });
    print("object updte false");
    print(_loading);

    widget.onChange();
  }

  void _showDetail(BuildContext context, Recipe recipe) {
    Navigator.pushNamed(context, "/detail", arguments: recipe);
  }
}
