import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/authenticate/authenticate.dart';
import 'package:mockingbirdapp/screens/navigation_screen.dart';
import 'package:mockingbirdapp/screens/test_headphones.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user != null) {
    }
    if (user == null) {
      return Authenticate();
    } else {
      return NavigationScreen();
    }
  }
}
