import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';
import 'package:mockingbirdapp/screens/wrapper.dart';
import 'package:mockingbirdapp/services/auth.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProjectStateProvider>(
          create: (context) => ProjectStateProvider(),
        ),
        StreamProvider<User>.value(
          value: AuthService().user,
        )
      ],
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}