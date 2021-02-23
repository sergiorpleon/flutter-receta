import 'package:receta/models/user.dart';

class Recipe{
int id;
String title;
String description;
List<String> ingredients;
List<String> steps;
String image;
List<int> userlikes;
User user;

Recipe({this.id, this.title, this.description, this.ingredients, this.steps, this.image, this.userlikes, this.user});

}