import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbirdapp/camera/gallery.dart';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';
import 'package:provider/provider.dart';
import 'package:mockingbirdapp/screens/camera_screen.dart';

class EditProject extends StatefulWidget {

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {

  _onBackPressed(p) {
    p.filePath = "";
    p.currentProjectID = "";
  }

@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectStateProvider>(
      builder: (context, projectStateProvider, child) {
        return WillPopScope(
          onWillPop: _onBackPressed(projectStateProvider),
          child: Scaffold(
              appBar: AppBar(
                title: Text('Edit Project '),
                centerTitle: true,
                backgroundColor: Colors.redAccent,
              ),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CameraPage(),
                              ),
                            );
                          },
                          child: Text("Record Video"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Gallery(),
                                )
                            );
                          },
                          child: Text("Preview"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: RaisedButton(
                          onPressed: (){
                          },
                          child: Text("Upload"),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        );
      },
    );
  }

}
