import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/empty_state.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/song_part.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/feed/view_video_screen.dart';
import 'package:mockingbirdapp/screens/projects/completed_screen.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/in_progress_screen/edit_project_screen.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/rendering_project_screen.dart';
import 'package:mockingbirdapp/services/project_service.dart';
import 'package:mockingbirdapp/services/song_parts.dart';
import 'package:provider/provider.dart';

class EditProjectWrapper extends StatefulWidget {
  String projectId;
  String projectName;
  EditProjectWrapper({ this.projectId, this.projectName });


  @override
  _EditProjectWrapperState createState() => _EditProjectWrapperState();
}

class _EditProjectWrapperState extends State<EditProjectWrapper> {
  Project currentProject;
  User currentUser;
  List<SongPart> songParts = [];
  bool loading = true;
  String error = "";

  Future<void> _fetchSongParts() async {
    SongParts instance = SongParts(songId: currentProject.song.id);
    await instance.getSongParts();
    setState(() {
      songParts = instance.songParts;
    });
  }

  Future<void> _loadCurrentProject() async {
    ProjectService projectService = ProjectService(projectId: widget.projectId);
    currentProject = await projectService.getProject();
    if(currentProject == null){
      error = "Couldn't fetch project, check your internect connneection and try again";
    }
    await _fetchSongParts();
    setState(() { loading = false; });
  }

  reload(){
    print("reloading project");
    setState(() { loading = true; });
    _loadCurrentProject();
  }

  renderProject() async {
    setState(() { loading = true;});
    await currentProject.renderProject();
    reload();
    setState(() { loading = false;});
  }

  @override
  void initState() {
    currentUser =  Provider.of<User>(context, listen:false);
    _loadCurrentProject();
    super.initState();
  }

  Widget _checkProjectStatus() {
    switch (currentProject.status){
      case "started" : {
        return EditProjectScreen(
          currentProject: currentProject,
          currentUser: currentUser,
          songParts: songParts,
          reloadProject: (){reload();},
          renderProject: (){renderProject();},
        );
      }
      case "rendering" : {
        return RenderingScreen(
          reloadProject: (){reload();},
          project: currentProject,
        );
      }
      case "uploading" : {
        return RenderingScreen();
      }
      case "completed" : {
        return CompletedProjectScreen(musicVideoID: currentProject.musicVideo);
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: () async {
                await currentProject.deleteProjectDialog(context, (){ Navigator.pop(context);});
              },
            )
          ],
          title: Text(widget.projectName),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body:
        loading ? Loading(size: 50.0) :
        error != "" ? EmptyStateWidget(
          text: error,
          icon: Icons.error,
        ) : _checkProjectStatus()
    );
  }
}

