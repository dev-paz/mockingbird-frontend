import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/authenticate/authenticate.dart';
import 'package:mockingbirdapp/screens/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
