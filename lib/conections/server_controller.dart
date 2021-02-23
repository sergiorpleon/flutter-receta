import 'package:flutter/cupertino.dart';
import 'package:receta/models/receta.dart';
import 'package:receta/models/user.dart';

class ServerController {
  User currentUser;
  List<User> users;
  List<Recipe> recipes;

  void init(BuildContext context) {}

  ServerController() {
    currentUser = null;
    users = [
      User(
          id: 1,
          username: "user1",
          password: "user1",
          isMan: true,
          photo: "assets/usuarios/user1.png"),
      User(
          id: 2,
          username: "user2",
          password: "user2",
          isMan: true,
          photo: "assets/usuarios/user2.png"),
      User(
          id: 3,
          username: "user3",
          password: "user3",
          isMan: true,
          photo: "assets/usuarios/user3.png"),
    ];

    recipes = [
      Recipe(
        id: 1,
        title: "Natilla",
        description:
            "Las natillas son un postre lácteo muy extendido en la gastronomía española",
        ingredients: ["leche", "yemas de huevo", "azúcar", "vainilla"],
        steps: ["Mezclar los ingredientes", "Cocinar durante 30 minuos"],
        image: "assets/recetas/receta1.jpg",
        userlikes: [1],
        user: User(
            id: 1,
            username: "user1",
            password: "user1",
            isMan: true,
            photo: "assets/usuarios/user1.png"),
      ),
      Recipe(
        id: 2,
        title: "Flan",
        description:
            "El flan es un postre típico de la gastronomía de múltiples países",
        ingredients: ["huevos enteros", "leche", "azúcar"],
        steps: [
          "Mezclar los ingredientes",
          "Cocinar en baño María con caramelo en la capa inferior (superior al servirlo)",
          "Una vez terminada la cocción invertir el molde, quedando cubierto el flan con el caramelo",
        ],
        image: "assets/recetas/receta2.jpg",
        userlikes: [2],
        user: User(
            id: 2,
            username: "user2",
            password: "user2",
            isMan: true,
            photo: "assets/usuarios/user2.png"),
      ),
      Recipe(
        id: 3,
        title: "Arroz con Leche",
        description:
            "El arroz con leche es un postre típico de la gastronomía de múltiples países hecho cociendo lentamente arroz con leche y azúcar",
        ingredients: ["arroz", "leche", "azucar"],
        steps: [
          "El arroz se cuece a fuego lento en leche con azúcar, y vainilla (también se puede espesar con huevo, nata o harina, o en su defecto, usando leche abundantemente)"
        ],
        image: "assets/recetas/receta3.jpg",
        userlikes: [3],
        user: User(
            id: 3,
            username: "user3",
            password: "user3",
            isMan: true,
            photo: "assets/usuarios/user3.png"),
      ),
      Recipe(
        id: 4,
        title: "Buñuelo",
        description: "El buñuelo es una masa de harina que se fríe",
        ingredients: ["harina", "huevos enteros", "aceite"],
        steps: [
          "Se mezclan harina y huevos batidos",
          "Se hacen bolas que se fríen"
        ],
        image: "assets/recetas/receta4.jpg",
        userlikes: [],
        user: User(
            id: 1,
            username: "user1",
            password: "user1",
            isMan: true,
            photo: "assets/usuarios/user1.png"),
      ),
      Recipe(
        id: 5,
        title: "Torrija",
        description:
            "La torrija es un dulce de origen europeo de larga tradición en España",
        ingredients: ["pan", "leche", "huevo entero", "aceite"],
        steps: [
          "Rebanar pan (habitualmente de varios días)",
          "Empapar en leche",
          "Rebozar en huevo",
          "Freir en una sartén con aceite"
        ],
        image: "assets/recetas/receta5.jpg",
        userlikes: [1, 2, 3],
        user: User(
            id: 1,
            username: "user1",
            password: "user1",
            isMan: true,
            photo: "assets/usuarios/user1.png"),
      ),
      Recipe(
        id: 6,
        title: "Churro",
        description:
            "El churro es una masa a base de harina de trigo cocinada en aceite, una comida de las denominadas frutas de sartén",
        ingredients: ["harina", "agua", "sal", "azucar", "aceite"],
        steps: [
          "Crear una masa compuesta por harina, agua, y sal",
          "Colocarla en un aparato cilíndrico similar a una manga pastelera y se empuja con un pistón sobre una boquilla por donde sale mediante extrusión, y con sección trasversal en forma de estrella",
          "Freir en aceite",
          "Rebozar en azúcar"
        ],
        image: "assets/recetas/receta6.jpg",
        userlikes: [1, 2, 3],
        user: User(
            id: 1,
            username: "user1",
            password: "user1",
            isMan: true,
            photo: "assets/usuarios/user1.png"),
      ),
    ];
  }

  void setCurrentUser(User user) {
    this.currentUser = user;
  }

  User getCurrentUser() {
    return this.currentUser;
  }

  Future<User> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1));
    for (var user in users) {
      if (user.login(username, password)) {
        return user;
      }
    }
    return null;
  }

  Future<bool> addUser(User user) async {
    await Future.delayed(Duration(seconds: 1));
    users.add(user);
    return true;
  }

  Future<bool> updateUser(User user) async {
    await Future.delayed(Duration(seconds: 1));
    int index = -1;
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == user.id) {
        users[i].username = user.username;
        users[i].password = user.password;
        users[i].isMan = user.isMan;
        users[i].photo = user.photo;
        index = i;
      }
    }
    if (index > -1) {}
    return true;
  }

  Future<bool> addRecipe(Recipe recipe) async {
    recipes.add(recipe);
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    await Future.delayed(Duration(seconds: 1));
    int index = -1;
    for (var i = 0; i < recipes.length; i++) {
      if (recipes[i].id == recipe.id) {
        recipes[i].title = recipe.title;
        recipes[i].description = recipe.description;
        recipes[i].ingredients = recipe.ingredients;
        recipes[i].steps = recipe.steps;
        recipes[i].user = recipe.user;
        recipes[i].image = recipe.image;
        index = i;
      }
    }
    if (index > -1) {}
    return true;
  }

  Future<List<Recipe>> getRecipeList() async {
    await Future.delayed(Duration(seconds: 2));
    List<Recipe> returnrecipes = this.recipes.toList();
    return returnrecipes;
  }

  Future<List<Recipe>> getFavoriteList(User user) async {
    await Future.delayed(Duration(seconds: 2));
    List<Recipe> favoriterecipes = [];
    for (var recipe in recipes) {
      if (recipe.userlikes != null) {
        for (var item in recipe.userlikes) {
          if (item == user.id) {
            favoriterecipes.add(recipe);
          }
        }
      }
    }
    return favoriterecipes.toList();
  }

  Future<List<Recipe>> getMyRecipeList(User user) async {
    await Future.delayed(Duration(seconds: 2));
    List<Recipe> myrecipes = [];
    for (var recipe in recipes) {
      if (user.id == recipe.user.id) {
        myrecipes.add(recipe);
      }
    }
    return myrecipes.toList();
  }

  Future<bool> updateFavorite(Recipe recipe, User user) async {
    await Future.delayed(Duration(seconds: 2));
    int indexrecipe = -1;
    int indexfavorite = -1;
    for (var i = 0; i < recipes.length; i++) {
      if (recipes[i].id == recipe.id) {
        indexrecipe = i;
        if (recipes[i].userlikes != null) {
          for (var j = 0; j < recipes[i].userlikes.length; j++) {
            if (recipes[i].userlikes[j] == user.id) {
              indexfavorite = j;
            }
          }
        }
      }
    }
    if (indexrecipe > -1 && indexfavorite > -1) {
      (recipes[indexrecipe].userlikes).removeAt(indexfavorite);
    } else if (indexrecipe > -1) {
      (recipes[indexrecipe].userlikes).add(user.id);
    }
    return true;
  }
}
