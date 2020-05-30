import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/empty_state.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/music_video.dart';
import 'package:mockingbirdapp/screens/feed/music_video_card.dart';
import 'package:mockingbirdapp/screens/feed/thumbnail_card.dart';
import 'package:mockingbirdapp/services/music_video_service.dart';

class MainFeed extends StatefulWidget {
  @override
  _MainFeedState createState() => _MainFeedState();
}

class _MainFeedState extends State<MainFeed> {
  bool loading = true;
  String error = "";
  List<MusicVideo> musicVideos;

  void _fetchMusicVideos() async {
    MusicVideoService mvService = MusicVideoService();
    musicVideos = await mvService.getAllMusicVideos();
    if (musicVideos == null){
      error = "No music videos to show";
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _fetchMusicVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[200],
      body: error != "" ? Center(
          child: EmptyStateWidget(
            text: error,
            icon: Icons.queue_music,
          )
      ) : SingleChildScrollView(
        child: Column(
          children: musicVideos.map((mv){
            if (mv.public == true) {
              return ThumbnailCard(
                  id: mv.id,
                  songId: mv.songId,
                  created: mv.created,
                  url: mv.url,
                  ownerPhoto: mv.ownerPhoto,
                  songName: mv.songTitle,
                  ownerName: mv.ownerName,
                  image: mv.albumArt
              );
            }
            return Container();
          }).toList(),
        ),
      ),
    );
  }
}
