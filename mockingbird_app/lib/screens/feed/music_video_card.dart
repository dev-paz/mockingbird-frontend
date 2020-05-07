import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/screens/feed/video_player.dart';
import 'package:mockingbirdapp/services/music_video_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/src/chewie_player.dart';

class MusicVideoCard extends StatefulWidget {
  String url;
  String created;
  String songId;
  String id;

  MusicVideoCard({ this.url, this.id, this.created, this.songId });

  @override
  _MusicVideoCardState createState() => _MusicVideoCardState();
}



class _MusicVideoCardState extends State<MusicVideoCard> {
  bool loading = true;
  String downloadURL;

  String username = 'cloud-admin';
  String password = 'UZTWLVEr6n';

  void  _initVideo() async {
    MusicVideoService mvService = MusicVideoService();
    downloadURL = await mvService.getDownloadURL(widget.url);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(size: 50.0) : Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text("User's name here"),
            subtitle: Text(widget.created),
          ),
          Center(
            child: Container(
                child: MusicVideoPlayer(url: downloadURL))
          )
        ],
      ),
    );
  }
}
