import 'package:chewie_audio/chewie_audio.dart';
import 'package:chewie_audio/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class AudioPlayer extends StatefulWidget {

  AudioPlayer({this.title = 'Chewie Audio Demo', this.audioFile});
  final String title;
  final String audioFile;
  //'https://www.w3schools.com/tags/horse.mp3'
  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<AudioPlayer> {
  VideoPlayerController _videoPlayerController1;
  ChewieAudioController _chewieAudioController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.audioFile);
    _chewieAudioController = ChewieAudioController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blueAccent,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey[200],
        bufferedColor: Colors.grey[600],
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieAudioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: ChewieAudio(
                  controller: _chewieAudioController,
                ),
              ),
            ),
          ],
        );
  }
}