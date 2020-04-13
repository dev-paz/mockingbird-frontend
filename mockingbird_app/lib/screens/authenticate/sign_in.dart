import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/contants.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn( {this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();


  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
        backgroundColor: Colors.red,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: (){widget.toggleView();},
              icon: Icon(Icons.person),
              label: Text("Register")
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
              Container(
                child: loading ? Loading(size: 30.0) : RaisedButton(
                  color: Colors.pink,
                  child: Text(
                    "Sign In",
                    style: TextStyle( color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null){
                        setState(() {
                          error = "Please give a valid email";
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
