import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/contants.dart';
import 'package:mockingbirdapp/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register( {this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password= "";
  String error = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Register"),
          backgroundColor: Colors.red,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: (){widget.toggleView();},
                icon: Icon(Icons.person),
                label: Text("Sign In")
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    validator: (v) => v.isEmpty ? "Enter an email" : null,
                    onChanged: (v){
                      setState(() {
                        email = v;
                      });
                    }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Password"),
                    validator: (v) => v.length < 6 ? "Enter a password with more than 6 letters" : null,
                    obscureText: true,
                    onChanged: (v){
                      setState(() {
                        password = v;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.pink,
                    child: Text(
                      "Register",
                      style: TextStyle( color: Colors.white),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if (result == null){
                          setState(() {
                            error = "Please give a valid email";
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 20))
                ],
              ),
            )
        )
    );
  }
}
