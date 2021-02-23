import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receta/components/image_picker.dart';
import 'package:receta/components/ingredient_widget.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/receta.dart';
import 'package:receta/models/user.dart';

class AddRecipePage extends StatefulWidget {
  ServerController _serverController;
  Recipe recipeEdit;

  AddRecipePage(this._serverController, {Key key, this.recipeEdit})
      : super(key: key);

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  bool _loading = false;
  bool _editingrecipe = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
  String _title;
  String _description;
  List<String> ingredientList = [];
  final nIngredientController = TextEditingController();
  List<String> stepList = [];
  final nPasoController = TextEditingController();
  User creator;
  //dynamic _gener = 1;
  String _errorMessage = "";

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        
        if(_editingrecipe){
           Navigator.pop(context, widget.recipeEdit);
          //Recipe recipe = widget.recipeEdit;
          //Navigator.pop(context);
          //Navigator.of(context).pushNamed("/detail", arguments: recipe);
        }else{
          Navigator.pop(context);
        }
        
        return false;
      },
      child: Scaffold(
        key: _scaffKey,
        body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.cyan[300],
                  Colors.cyan[800],
                ])),
                child: ImagePickerWidget(
                    imageFile: this.imageFile,
                    onImageSelected: (File file) {
                      setState(() {
                        imageFile = file;
                      });
                    }),
              ),
              SizedBox(
                height: kToolbarHeight + 25,
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  //leading: new IconButton(
                  //  icon: new Icon(Icons.arrow_back),
                    //onPressed: () {
                    //  Navigator.pop(context, widget.recipeEdit);
                    //},
                  //),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          _doProcess(context);
                        })
                  ],
                ),
              ),
              Center(
                child: Container(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 260, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 35, horizontal: 20),
                      child: ListView(
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            initialValue: _title,
                            decoration:
                                InputDecoration(labelText: "Nombre de receta"),
                            onSaved: (value) {
                              _title = value;
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Este campo es obligatorio";
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            initialValue: _description,
                            decoration: InputDecoration(
                              labelText: "Descripción",
                            ),
                            onSaved: (value) {
                              _description = value;
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Este campo es obligatorio";
                            },
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            title: Text("Ingredientes"),
                            trailing: FloatingActionButton(
                              heroTag: 'uno',
                              child: Icon(Icons.add),
                              onPressed: () {
                                _ingredientDialog(context);
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          getIngredientList(),
                          SizedBox(height: 20),
                          ListTile(
                            title: Text("Pasos"),
                            trailing: FloatingActionButton(
                              heroTag: 'dos',
                              child: Icon(Icons.add),
                              onPressed: () {
                                _stepDialog(context);
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          getStepList(),
                          SizedBox(height: 20),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(_editingrecipe
                                        ? "Actualizar"
                                        : "Crear"),
                                    if (_loading)
                                      Container(
                                          width: 20,
                                          height: 20,
                                          margin: EdgeInsets.only(left: 20),
                                          child: CircularProgressIndicator()),
                                  ],
                                ),
                                onPressed: () {
                                  _doProcess(context);
                                }),
                          ),
                          if (!_errorMessage.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _editingrecipe = false;
    super.dispose();

  }

  void _doProcess(BuildContext context) async {
    if (!_loading) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        if (imageFile == null) {
          _showSnackBar(
              context, "Seleccione una imagen por favor", Colors.orange);
          return;
        }
        if (ingredientList.length == 0) {
          _showSnackBar(context, "No tiene ingrediente", Colors.orange);
          return;
        }
        if (stepList.length == 0) {
          _showSnackBar(context, "No tiene pasos", Colors.orange);
          return;
        }

        setState(() {
          _loading = true;
          _errorMessage = "";
        });
        Recipe recipe = Recipe(
            title: _title,
            description: _description,
            ingredients: ingredientList,
            steps: stepList,
            user: widget._serverController.currentUser,
            image: imageFile.path);
        var state;
        if (_editingrecipe) {
          int id = widget.recipeEdit.id;
          recipe.id = id;
          print("UPDATE");
          state = await widget._serverController.updateRecipe(recipe);
        } else {
          state = await widget._serverController.addRecipe(recipe);
        }
        if (state) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Información"),
                  content: Text(_editingrecipe
                      ? "La receta ha sido actualizado exitosamente"
                      : "La receta ha sido creada exitosamente"),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context, recipe);
                        }),
                  ],
                );
              });
        } else {
          _showSnackBar(context, "No se pudo guardar", Colors.orange);
        }
        _loading = false;
      }
    }
  }

  void _showSnackBar(BuildContext context, String title, Color backColor) {
    this._scaffKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: backColor,
          ),
        );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _editingrecipe = widget.recipeEdit != null;
    if (_editingrecipe) {
      _title = widget.recipeEdit.title;
      _description = widget.recipeEdit.description;
      ingredientList = widget.recipeEdit.ingredients;
      stepList = widget.recipeEdit.steps;
      creator = widget.recipeEdit.user;
      //_gener = widget.userEdit.isMan ? 1 : 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getUserImageFile(widget.recipeEdit.image).then((result) {
          print("result: $result");
          setState(() {});
        });
      });
    }
  }

  void _onIngredientEdit(int index) {
    final ingredient = ingredientList[index];
    _ingredientDialog(context, ingredient: ingredient, index: index);
  }

  void _onIngredientDelete(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Seguro que deseas eliminar el ingrediente?"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    ingredientList.removeAt(index);
                    Navigator.pop(context);
                  });
                },
                child: Text("Eiliminar"),
              ),
            ],
          );
        });
    //    questionDialog(context, "Seguro que deseas eliminar el ingrediente?", (){
    //      setState(() {
    //      ingredientList.removeAt(index);
    //      });
    //    });
  }

  void _onStepEdit(int index) {
    final step = stepList[index];
    _stepDialog(context, step: step, index: index);
  }

  void _onStepDelete(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Seguro que deseas eliminar el paso?"),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    stepList.removeAt(index);
                    Navigator.pop(context);
                  });
                },
                child: Text("Eiliminar"),
              ),
            ],
          );
        });
    //       questionDialog(context, "Seguro que deseas eliminar el paso?", (){
    //         setState(() {
    //         stepList.removeAt(index);
    //         });
    //       });
  }

  Future<bool> getUserImageFile(String path) async {
    imageFile = await createFileOfImageUrl(path);
    return true;
  }

  Future<File> createFileOfImageUrl(String imagepath) async {
    final List<String> arraypath = imagepath.split("/");
    final filename = arraypath[arraypath.length - 1];
    var bytes = await rootBundle.load(imagepath);
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    File file = new File('$dir/$filename');

    return file;
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  void _ingredientDialog(BuildContext context, {String ingredient, int index}) {
    final TextEditingController textController =
        TextEditingController(text: ingredient);
    final bool editing = ingredient != null;
    final onSave = () {
      print("SALVAR INGREDIENTE");
      print(ingredient);
      print(textController.text);
      final text = textController.text;
      if (text.isEmpty) {
        _showSnackBar(context, "El ingrediente esta vacio", Colors.orange);
      } else {
        setState(() {
          if (editing) {
            print("CREATE INGREDIENTE");
            ingredientList[index] = text;
            print(ingredient);
          } else {
            print("EDITING INGREDIENTE");
            print(ingredient);
            ingredientList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(editing ? "Editando ingrediente" : "Agregando ingrediente"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "Ingrediente",
            ),
            //onEditingComplete: onSave(),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () {
                onSave();
              },
              child: Text(editing ? "Actualizar" : "Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _stepDialog(BuildContext context, {String step, int index}) {
    print("SALVAR PASO 00");
    final TextEditingController textController =
        TextEditingController(text: step);
    final bool editing = step != null;
    final onSave = () {
      print("SALVAR PASO");
      final text = textController.text;
      if (text.isEmpty) {
        _showSnackBar(context, "El paso esta vacio", Colors.orange);
      } else {
        setState(() {
          if (editing) {
            stepList[index] = text;
          } else {
            stepList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(editing ? "Editando paso" : "Agregando Paso"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "Paso",
            ),
            //onEditingComplete: onSave(),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () {
                onSave();
              },
              child: Text(editing ? "Actualizar" : "Guardar"),
            ),
          ],
        );
      },
    );
  }

  Widget getIngredientList() {
    if (ingredientList == null || ingredientList.length == 0) {
      return Text(
        "Lista vacia",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: List.generate(ingredientList.length, (index) {
          final ingredient = ingredientList[index];
          return IngredientWidget(
              index: index,
              ingredient: ingredient,
              onIngredientDeleteCallback: _onIngredientDelete,
              onIngredientEditCallback: _onIngredientEdit);
        }),
      );
    }
  }

  Widget getStepList() {
    if (stepList == null || stepList.length == 0) {
      return Text(
        "Lista vacia",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return Column(
        children: List.generate(stepList.length, (index) {
          final ingredient = stepList[index];
          return IngredientWidget(
              index: index,
              ingredient: ingredient,
              onIngredientDeleteCallback: _onStepDelete,
              onIngredientEditCallback: _onStepEdit);
        }),
      );
    }
  }
}
