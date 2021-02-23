import 'package:flutter/material.dart';
import 'package:receta/conections/server_controller.dart';
import 'package:receta/models/user.dart';

class LoginPage extends StatefulWidget {
  ServerController _serverController;

  LoginPage(this._serverController);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;
  String _password;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: Text("Login"),
      //),

      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 60,
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.cyan[300],
                Colors.cyan[800],
              ])),
              child: Image.asset(
                'assets/logo.png',
                height: 200,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: "Usuario"),
                          onSaved: (value) {
                            _username = value;
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "Este campo es obligatorio";
                          },
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Contraseña"),
                          obscureText: true,
                          onSaved: (value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return "Este campo es obligatorio";
                          },
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
                                  Text("Iniciar sessión"),
                                  if (_loading)
                                    Container(
                                        width: 20,
                                        height: 20,
                                        margin: EdgeInsets.only(left: 20),
                                        child: CircularProgressIndicator()),
                                ],
                              ),
                              onPressed: () {
                                _login(context);
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
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("No estas registrado"),
                            FlatButton(
                              textColor: Theme.of(context).primaryColor,
                              onPressed: () {
                                _showRegister(context);
                              },
                              child: Text("Registrarse"),
                            ),
                          ],
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
    );
  }

  void _login(BuildContext context) async{
    if (!_loading) {
      if(_formKey.currentState.validate()){
        _formKey.currentState.save();
        setState(() {
        _loading = true;
         _errorMessage = "";
      });
      User user = await widget._serverController.login(_username, _password);
      if (user != null) {
        Navigator.of(context).pushReplacementNamed("/home", arguments: user);
      }else{
        setState(() {
          _errorMessage = "Usuario o  contraseña incorrecto";
        });
      }
      _loading = false;
      }
    }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed("/register");
  }
}
