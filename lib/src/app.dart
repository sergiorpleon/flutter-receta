import 'package:flutter/material.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/receta.dart';
import 'package:receta/models/user.dart';
import 'package:receta/screen/add_recipe_page.dart';
import 'package:receta/screen/detail_page.dart';
import 'package:receta/screen/home_page.dart';
import 'package:receta/screen/login_page.dart';
import 'package:receta/screen/my_favorite_page.dart';
import 'package:receta/screen/my_recipe.dart';
import 'package:receta/screen/register_page.dart';

class MyApp extends StatelessWidget {
  ServerController _serverController = ServerController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receta de cocina',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        accentColor: Colors.cyan[800],
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.cyan,

        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings setting) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (setting.name) {
            case "/":
              return LoginPage(_serverController);
              break;
            case "/register":
              User currentUser = setting.arguments;
              return RegisterPage(_serverController, userEdit: currentUser);
              break;
            case "/edit_recipe":
              Recipe currentRecipe = setting.arguments;
              return AddRecipePage(_serverController,
                  recipeEdit: currentRecipe);
              break;
            case "/home":
              User logged = setting.arguments;
              _serverController.setCurrentUser(logged);
              return HomePage(_serverController);
              break;
            case "/detail":
              if (setting.arguments != null) {
                Recipe recipe = setting.arguments;
                return DetailPage(
                    recipe: recipe, serverController: _serverController);
              }
              return DetailPage(serverController: _serverController);
              break;
            case "/user_recipes":
              return MyRecipePage(_serverController);
              break;
            case "/favorites":
              return MyFavoritePage(_serverController);
              break;
            default:
          }
        });
      },
    );
  }
}
