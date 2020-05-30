import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/screens/feed/video_player.dart';
import 'package:mockingbirdapp/services/music_video_service.dart';

class ViewVideoScreen extends StatefulWidget {
  String url;
  String created;
  String songId;
  String id;
  ViewVideoScreen({ this.url, this.id, this.created, this.songId });
  @override
  _ViewVideoScreenState createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends State<ViewVideoScreen> {
  String downloadURL;
  bool loading = true;

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
    return Scaffold(
      appBar: AppBar(),
      body: loading ? Loading(size: 50.0) : Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MusicVideoPlayer(
                url: downloadURL,
              )
            ],
          ),
        ),
      ),
    );
  }
}
