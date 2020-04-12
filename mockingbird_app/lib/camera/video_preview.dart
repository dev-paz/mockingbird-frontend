import 'dart:io';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';
import 'package:flutter/material.dart';
import 'package:mockingbirdapp/camera/video_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({this.videoPath});

  final String videoPath;
  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  VideoPlayerController _controller;
  bool loading = true;
  bool firstPass = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  resetState(filePath) async {
    print("Resetting the state");
    if (_controller != null){
      await _controller.dispose();
    }
    _controller = await VideoPlayerController.file(File(filePath))
      ..initialize().then(
            (_) {
          setState(() {
            firstPass = false;
          });
        },
      );
  }


  @override
  Widget build(BuildContext context) {
    final projectStateProvider = Provider.of<ProjectStateProvider>(context);
    print("is first pass");
    print(firstPass);
    if(!firstPass){
      firstPass = true;
      if (_controller.value.initialized) {
        num newAspectRatio = 4/3;
        return Stack(
          children: <Widget>[
            Center(
              child: AspectRatio(
                aspectRatio: 4/3,
                child: ClipRect(
                  child: Transform.scale(
                      scale:  newAspectRatio /_controller.value.aspectRatio ,
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller)
                        ),
                      )
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoControls(
                videoController: _controller,
              ),
            ),
          ],
        );
      } else {
        print("not initialised");
        return Center(
          child: AspectRatio(
            aspectRatio: 4/3,
            child: ClipRect(
              child: Transform.scale(
                  scale:  1,
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Image.asset('assets/dd.jpeg'),
                        ),
                    ),
                  )
              ),
            ),
          );
      }
    } else{
      resetState(projectStateProvider.filePath);
      num newAspectRatio = 4/3;
      return Center(
        child: AspectRatio(
          aspectRatio: newAspectRatio,
          child: ClipRect(
              child:Transform.scale(
                scale:  1.35,
                child: Center(
                  child: Image.network(
                    'https://m.media-amazon.com/images/M/MV5BOGZlOTQ2OTgtZmQ4Ni00Nzk0LWI0ZTEtMDRlNGU5ZGRhZjgwXkEyXkFqcGdeQXVyOTc5MDI5NjE@._V1_.jpg',
                  ),
                ),
              )
          )
          ),
      );
    }
  }
}