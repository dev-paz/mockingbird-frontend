import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/empty_state.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/services/project_service.dart';

class RenderingScreen extends StatefulWidget {
  Project project;
  Function reloadProject;

  RenderingScreen({ this.reloadProject, this.project });

  @override
  _RenderingScreenState createState() => _RenderingScreenState();
}


class _RenderingScreenState extends State<RenderingScreen> {
  ProjectService projectService = ProjectService();
  double renderProgress = 0.0;
  bool loading = true;
  Project currentProject;
  bool projectCompleted;
  String error = "";
  Timer _timer;

  void _checkRenderStatus() async {
    double progress = await widget.project.checkRenderStatus();
    if (progress == null){
      setState(() {
        error = "Couldn't get project status";
      });
      _timer.cancel();
    }
    setState(() {
      loading = false;
      renderProgress = progress;
    });

    _timer = Timer.periodic(new Duration(seconds: 5), (timer) async {
      print("next loop is starting now");
      if (renderProgress < 99.9) {
        double progress = await widget.project.checkRenderStatus();
        if (progress == null){
          setState(() {
            error = "Couldn't get project status";
          });
          _timer.cancel();
        }
        setState(() {
          renderProgress = progress;
        });
      } else {
        currentProject = await projectService.getProject();
        if (currentProject.status == "completed") {
          widget.reloadProject();
          _timer.cancel();
        }
      }
    });
  }


  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  void initState() {
    currentProject = widget.project;
    projectService.projectId = currentProject.id;
    _checkRenderStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Re rendering the render loader screen");
    return loading ? Loading(size: 50.0) :
        error != "" ? Center(
          child: EmptyStateWidget(
            text: error,
            icon: Icons.error,
          ),
        ) :
        Stack(
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: renderProgress > 99 ? null : (renderProgress/100),
                  strokeWidth: 8,
                ),
              ),
            ),
            Center(
              child: renderProgress > 99 ?
              Text("Almost done!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Text("$renderProgress%",
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 12),
                  Text("Render Progress",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                    ),
                  )
                ]
              )
            )
          ]
    );
  }
}
