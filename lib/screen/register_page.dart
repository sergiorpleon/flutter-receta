import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receta/components/image_picker.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/user.dart';

class RegisterPage extends StatefulWidget {
  ServerController _serverController;
  User userEdit;

  RegisterPage(this._serverController, {Key key, this.userEdit})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _loading = false;
  bool _showPassword = false;
  bool _editinguser = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
  String _username;
  String _password;
  dynamic _gener = 1;
  String _errorMessage = "";

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
            ),
            Center(
              child: Container(
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
                            initialValue: _username,
                            decoration: InputDecoration(labelText: "Usuario"),
                            onSaved: (value) {
                              _username = value;
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Este campo es obligatorio";
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            initialValue: _password,
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              suffixIcon: IconButton(
                                icon: Icon(_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_showPassword,
                            onSaved: (value) {
                              _password = value;
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Este campo es obligatorio";
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Genero:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      RadioListTile(
                                        title: Text("Masculino"),
                                        value: 1,
                                        groupValue: _gener,
                                        onChanged: (value) {
                                          setState(() {
                                            _gener = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: Text("Femenino"),
                                        value: 0,
                                        groupValue: _gener,
                                        onChanged: (value) {
                                          setState(() {
                                            _gener = value;
                                          });
                                        },
                                      ),
                                    ]),
                              ),
                            ],
                          ),
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
                                    Text(_editinguser
                                        ? "Actualizar"
                                        : "Registrar"),
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
            ),
          ],
        ),
      ),
    );
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
        setState(() {
          _loading = true;
          _errorMessage = "";
        });
        User user = User(
            username: _username,
            password: _password,
            isMan: _gener == 1,
            photo: imageFile.path);
        var state;
        if (_editinguser) {
          int id = widget._serverController.currentUser.id;
          user.id = id;
          state = await widget._serverController.updateUser(user);
        } else {
          state = await widget._serverController.addUser(user);
        }
        if (state) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Información"),
                  content: Text(_editinguser
                      ? "Su usuario ha sido actualizado exitosamente"
                      : "Su usuario ha sido registrado exitosamente"),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context, user);
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

    _editinguser = widget.userEdit != null;
    if (_editinguser) {
      _username = widget.userEdit.username;
      _password = widget.userEdit.password;
      _gener = widget.userEdit.isMan ? 1 : 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getUserImageFile(widget.userEdit.photo).then((result) {
          print("result: $result");
          setState(() {});
        });
      });
    }
  }

  Future<bool> getUserImageFile(String path) async {
    imageFile = await createFileOfImageUrl(path);
    return true;
  }

  Future<File> createFileOfImageUrl(String imagepath) async {
    final List<String> arraypath = imagepath.split("/");
    final filename = arraypath[arraypath.length-1];
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
}
