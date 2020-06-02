import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/project_clip.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/song_part.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/camera/camera_setup.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/in_progress_screen/completed_card.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/in_progress_screen/current_user_card.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/in_progress_screen/title_card.dart';
import 'friends_parts_card.dart';

// ignore: must_be_immutable
class EditProjectScreen extends StatefulWidget {
  Project currentProject;
  List<SongPart> songParts = [];
  Function reloadProject;
  Function renderProject;
  User currentUser;

  EditProjectScreen({
    this.currentProject,
    this.songParts,
    this.reloadProject,
    this.currentUser,
    this.renderProject
  });

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  List<Icon> stars = [];
  bool fileExists = false;
  bool projectReadyToSubmit = false;

  SongPart _getSelectedSongPart(ProjectClip clip){
    SongPart currentPart;
    for(var i = 0; i < widget.songParts.length; i++ ) {
      if(widget.songParts[i].id == clip.partId){
        currentPart = widget.songParts[i];
        break;
      }
    }
    return currentPart;
  }

  void _openCamera(ProjectClip clip){
    SongPart currentPart = _getSelectedSongPart(clip);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
          CameraSetup(
              songPart: currentPart,
              currentClip: clip,
              songLength: widget.currentProject.song.length
          ),
      ),
    );
    _deleteFile(clip);
  }

  void _deleteFile(ProjectClip clip) async {
    String filePath = await clip.getLocalFilePath();
    try {
      final dir = Directory(filePath);
      dir.deleteSync(recursive: true);
    }catch(e){
      print("no file here to delete");
    }
  }

  void _setupStars(){
    List<Icon> newStars = [];
    for(var i = 0; i < widget.currentProject.song.difficulty; i++ ) {
      newStars.add(Icon(Icons.star, color: Colors.pink, size: 20));
    }
    for(var i = 0; i < 5 - widget.currentProject.song.difficulty; i++ ) {
      newStars.add(Icon(Icons.star, color: Colors.grey, size: 20));
    }
    stars = newStars;
  }
  void _checkReadyToSubmit(){
    int counter = 0;
    for(var i = 0; i < widget.currentProject.clips.length; i++ ) {
      if(widget.currentProject.clips[i].file != ""){
        counter++;
      }
    }
    if(counter == widget.currentProject.clips.length){
      projectReadyToSubmit = true;
    }
    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    _setupStars();
    _checkReadyToSubmit();
    return
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           titleCard(stars, projectReadyToSubmit, widget.renderProject, widget.currentProject),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text("Your parts"),
            ),
            Column(
              children: widget.currentProject.clips.map((c) =>
               _isCurrentUserClip(c, true)
              ).toList(),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text("Friends Recordings"),
            ),
            Column(
              children: widget.currentProject.clips.map((c) =>
                  _isCurrentUserClip(c, false)
              ).toList(),
            )
          ],
        ),
      );
    }

  Widget _isCurrentUserClip(ProjectClip clip, bool isCurrentUser){
    if (isCurrentUser && clip.userId == widget.currentUser.firebaseUserId){
      return clip.file != "" ? CompletedPartsCard(projectClip: clip) : CurrentUserCard(
        songPart: _getSelectedSongPart(clip),
        currentClip: clip,
        uploadComplete:(){widget.reloadProject();},
        recordPressed: (){
          _openCamera(clip);
        },
      );
    } else if (!isCurrentUser && clip.userId != widget.currentUser.firebaseUserId){
      return friendsPartsCard(clip);
    }
    return Container();
  }
}


