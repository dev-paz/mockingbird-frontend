import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestHeadphones extends StatefulWidget {
  @override
  _TestHeadphonesState createState() => _TestHeadphonesState();
}

class _TestHeadphonesState extends State<TestHeadphones> {
  VideoPlayerController _videoController;

  @override
  void initState() {
    _videoController = VideoPlayerController.network("https://firebasestorage.googleapis.com/v0/b/mockingbird-287ec.appspot.com/o/songVideos%2FStay%20another%20day%2Fstay%20another%20day%20backing.mp4?alt=media&token=bca5d290-e0a0-4d6b-84a1-7e5759facfc1")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      !_videoController.value.initialized ? Container() :
      Column(
        children: <Widget>[
          Center(
            child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Center(
                  child: _videoController.value.initialized
                      ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                      : Container(),
                )
            ),
          ),
          RaisedButton(
            child: Text("Play"),
            onPressed: (){
              setState(() {
                _videoController.play();
              });
            },
          ),
          RaisedButton(
            child: Text("Pause"),
            onPressed: (){
              setState(() {
                _videoController.pause();
              });
            },
          )
        ],
      );

  }
}












