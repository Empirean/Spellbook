import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spellbook/services/authenticationservice.dart';
import 'package:spellbook/shared/loading.dart';
import 'package:spellbook/shared/textdecoration.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _email = "";
  String _password = "";
  String _errorText = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return Loading();
    }
    else
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            "Login",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          actions: [
            FlatButton.icon(
                onPressed: () {
                  widget.toggleView();
                },
                icon: Icon(
                  Icons.backup,
                  color: Colors.white,
                ),
                label: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ],
        ),
        body:
        Container(
          color: Colors.black87,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text(_errorText,
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 20,),
                Card(
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? "Please provide an email address" : null,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: textDecoration.copyWith(
                      hintText: "email@example.com",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _email = val;
                      });

                    },
                  ),
                ),
                Card(
                  child: TextFormField(
                    validator: (val) => val.length < 6 ? "Password needs to be longer than 6 characters" : null,
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: textDecoration.copyWith(
                      hintText: "password",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _password = val;
                      });
                    },

                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.orange)
                    ),
                    color: Colors.deepPurple,
                    onPressed: () async{
                      if (_formKey.currentState.validate())
                      {
                        _isLoading = true;
                        dynamic result = await AuthenticationService().signInEmail(_email, _password);
                        _isLoading = false;
                        setState(() {
                          _errorText = result;
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
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
  }
}
