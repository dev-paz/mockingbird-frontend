import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingbirdapp/camera/camera_setup.dart';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/screens/edit_project_screen.dart';
import 'package:mockingbirdapp/screens/home.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProjectStateProvider>(
      create: (context) => ProjectStateProvider(),
      child: MaterialApp(
          title: 'Camera',
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
            '/camera': (context) => CameraSetup(),
            '/edit_project' :(context) => EditProject(),
          }
      ),
    );
  }
}