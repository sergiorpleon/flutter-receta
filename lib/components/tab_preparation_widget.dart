import 'package:flutter/material.dart';
import 'package:receta/models/receta.dart';

class TabPreparationWidget extends StatelessWidget {
  final Recipe recipe;

  TabPreparationWidget(this.recipe);

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
          "Preparaciones",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: List.generate(
            recipe.steps.length,
            (int index) {
              final ingredient = recipe.steps[index];
              return ListTile(
                leading: Text("${index + 1}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                title: Text(ingredient),
              );
            },
          ),
        )
      ],
    );
  }
}
