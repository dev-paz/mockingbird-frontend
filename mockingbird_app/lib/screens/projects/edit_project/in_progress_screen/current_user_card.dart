import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/project_clip.dart';
import 'package:mockingbirdapp/models/song_part.dart';
import 'package:mockingbirdapp/screens/camera/video_preview.dart';
import 'package:mockingbirdapp/screens/projects/edit_project/in_progress_screen/preview_video_screen.dart';

class CurrentUserCard extends StatefulWidget {
  ProjectClip currentClip;
  SongPart songPart;
  Function recordPressed;
  Function uploadComplete;

  CurrentUserCard({ this.currentClip, this.recordPressed, this.uploadComplete, this.songPart });

  @override
  _CurrentUserCardState createState() => _CurrentUserCardState();
}

class _CurrentUserCardState extends State<CurrentUserCard> {
  double p = 0;
  bool uploadInProgress = false;
  String clipFilePath = "/var/mobile/Containers/Data/Application/B2B90156-E389-418F-8C57-FB9ECE10692B/Documents/media/clip_849b31eb-5b3a-4687-890c-7f8d39098492.mp4";

  bool _checkFileExists(filePath){
    print("made it here1");
    if(FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound){
      print("made it here2");
      return true;
    }

    print("made it here3");
    return false;
  }

  _progressIndicator(double completed){
    setState(() {
      p = completed;
    });
  }

   _uploadFile(ProjectClip clip) async {
     var file = File(clipFilePath);
     print(file.lengthSync());
     print (await file.length());

     setState(() {
      uploadInProgress = true;
    });
    clip.updateProgressIndicator = _progressIndicator;
    bool ok = await clip.uploadFileToProject(clipFilePath);
    if (!ok) {
      print("something went wrong!");
    }
    widget.uploadComplete();
   }

   _getClipFilePath() async {
     String fp = await widget.currentClip.getLocalFilePath();
    setState(() {
      clipFilePath = fp;
    });
   }

   @override
  void initState() {
     _getClipFilePath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(widget.currentClip.picture,
                  height: 40,
                  width: 40,
                ),
              ),
              subtitle: Text("This is the song you'll be re creating!"),
              title: Text("Lead vocals",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            uploadInProgress ? Padding(
              padding: const EdgeInsets.all(24.0),
              child: LinearProgressIndicator(value: p),
            ) : Container(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: uploadInProgress ? Container() :  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: _checkFileExists(clipFilePath) ? Row(
                      children: <Widget>[
                        RaisedButton.icon(
                          icon: Icon(Icons.movie, color: Colors.white, size: 20),
                          color: Colors.grey,
                          label: Text("Preview",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PreviewVideoScreen(file: clipFilePath, aspectRatio: widget.songPart.aspectRatio),
                              ),
                            );                          },
                        ),
                        SizedBox(width: 16),
                        RaisedButton.icon(
                          color: Colors.blue,
                          onPressed: (){
                            _uploadFile(widget.currentClip);
                          },
                          icon: Icon(Icons.cloud_upload, color: Colors.white, size: 20),
                          label: Text("Upload",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 16),
                        RaisedButton.icon(
                          icon: Icon(Icons.videocam, color: Colors.white, size: 20),
                          color: Colors.red,
                          label: Text("Record",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: (){
                            widget.recordPressed();
                          },
                        ),
                      ]
                    ): RaisedButton.icon(
                        icon: Icon(Icons.videocam, color: Colors.white, size: 20),
                        color: Colors.red,
                        label: Text("Record",
                          style: TextStyle(color: Colors.white),
                          ),
                        onPressed: (){
                          widget.recordPressed();
                        },
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


