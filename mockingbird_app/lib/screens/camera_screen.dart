import 'package:flutter/material.dart';
import 'package:mockingbirdapp/camera/camera_setup.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();

}

class _CameraPageState extends State<CameraPage> {
  final _cameraKey = GlobalKey<CameraSetupState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: CameraSetup(
        key: _cameraKey,
      ),
    );
  }
}
