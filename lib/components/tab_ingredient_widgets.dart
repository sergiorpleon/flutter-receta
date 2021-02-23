import 'package:flutter/material.dart';
import 'package:receta/models/receta.dart';

class TabIngredientsWidget extends StatelessWidget {
  final Recipe recipe;

  TabIngredientsWidget(this.recipe);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      children: <Widget>[
        Text(
          recipe.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          recipe.description,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Ingredientes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: List.generate(
            recipe.ingredients.length,
            (int index) {
              final ingredient = recipe.ingredients[index];
              return ListTile(
                
                leading: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                ),
                title: Text(ingredient),
              );
            },
          ),
        )
      ],
    );
  }
}
