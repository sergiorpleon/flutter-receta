import 'package:flutter/material.dart';
import 'package:receta/components/tab_ingredient_widgets.dart';
import 'package:receta/components/tab_preparation_widget.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/receta.dart';
import 'package:receta/models/user.dart';

class DetailPage extends StatefulWidget {
  Recipe recipe;
  final ServerController serverController;

  DetailPage({this.recipe, this.serverController});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _favorite;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoScrolled) {
            return [
              SliverAppBar(
                title: Text(
                  widget.recipe.title,
                  style: TextStyle(color: Colors.white),
                ),
                expandedHeight: 320,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(widget.recipe.image),
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                pinned: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  indicatorWeight: 4,
                  tabs: <Widget>[
                    Tab(
                      child:
                          Text("Ingredientes", style: TextStyle(fontSize: 18)),
                    ),
                    Tab(
                      child: Text("Preparaión", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                actions: <Widget>[
                  if (widget.recipe.user.id ==
                      widget.serverController.currentUser.id)
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final nRecipe = await Navigator.of(context).pushNamed(
                              "/edit_recipe",
                              arguments: widget.recipe);
                          setState(() {
                            widget.recipe = nRecipe;
                          });
                        }),
                  getFavoriteWidget(),
                  IconButton(icon: Icon(Icons.help_outline), onPressed: () {})
                ],
              ),
            ];
          },
          body: TabBarView(
            children: [
              TabIngredientsWidget(widget.recipe),
              TabPreparationWidget(widget.recipe),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFavoriteWidget() {
    if (_favorite != null) {
      if (_favorite) {
        return IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () async {
              await widget.serverController.updateFavorite(
                  widget.recipe, widget.serverController.currentUser);
              setState(() {
                _favorite = false;
              });
            });
      } else {
        return IconButton(
            icon: Icon(Icons.favorite_border_outlined, color: Colors.white),
            onPressed: () async {
              await widget.serverController.updateFavorite(
                  widget.recipe, widget.serverController.currentUser);
              setState(() {
                _favorite = true;
              });
            });
      }
    } else {
      return Container(
          width: 30,
          margin: EdgeInsets.all(15),
          child: CircularProgressIndicator());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _favorite = _isFavorite(widget.recipe);
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
}
