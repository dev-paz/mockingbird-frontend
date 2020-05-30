import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/music_video.dart';
import 'package:mockingbirdapp/screens/feed/video_player.dart';
import 'package:mockingbirdapp/services/music_video_service.dart';
import 'package:share/share.dart';

class CompletedProjectScreen extends StatefulWidget {
  String musicVideoID;
  CompletedProjectScreen({ this.musicVideoID });
  @override
  _CompletedProjectScreenState createState() => _CompletedProjectScreenState();
}

class _CompletedProjectScreenState extends State<CompletedProjectScreen> {
  String downloadURL;
  MusicVideo currentMusicVideo;
  bool loading = true;

  void  _initVideo() async {
    MusicVideoService mvService = MusicVideoService();
    downloadURL = await mvService.getDownloadURL(widget.musicVideoID + ".mp4");
    currentMusicVideo = await mvService.getMusicVideo(widget.musicVideoID);
    setState(() {
      loading = false;
    });
  }

  _reload(){
    loading = true;
    _initVideo();
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? Loading(size: 50.0) : Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MusicVideoPlayer(
                url: downloadURL,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: currentMusicVideo.public ? Icon(Icons.public, color: Colors.grey[600]) :
                    Icon(Icons.security, color: Colors.grey[600])
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: currentMusicVideo.public ? Text("This video is public", style: TextStyle(color: Colors.grey[600])) :
                    Text("This video is private", style: TextStyle(color: Colors.grey[600]))
                  )
                ]
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonBar(
                  children: <Widget>[
                    currentMusicVideo.public ? Container() : RaisedButton.icon(
                      onPressed: (){
                        MusicVideoService mvService = MusicVideoService();
                        mvService.postMusicVideoDialog(context, widget.musicVideoID, (){_reload();});
                      },
                      icon: Icon(Icons.arrow_upward),
                      label: Text("POST"),
                      color: Colors.pink,
                    ),
                    RaisedButton.icon(
                        onPressed: (){
                          Share.share('Have a look at Mockingbird ' + '\n\n' + downloadURL);
                        },
                        color: Colors.blueAccent,
                        icon: Icon(Icons.share),
                        label: Text("SHARE")
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
