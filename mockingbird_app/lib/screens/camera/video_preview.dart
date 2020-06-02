import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockingbirdapp/screens/camera/video_controls.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({this.videoPath, this.aspectRatio});

  final String videoPath;
  final double aspectRatio;
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
    print("printing video path");
    print(widget.videoPath);
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

  bool _checkFileExists(filePath){
    print(FileSystemEntity.typeSync(filePath));
    if(FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound){
      return true;
    }
    return false;
  }

  resetState() async {
    if (_controller != null){
      await _controller.dispose();
    }
    if (_checkFileExists(widget.videoPath)){
      print("file ready");
      _controller = await VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then(
              (_) {
            setState(() {
              firstPass = false;
            });
          },
        ).catchError((e) {
          print("printing error qwgqergqew");
          print(e);
        });
    } else {print("file not ready");}
  }

  @override
  Widget build(BuildContext context) {
    Offset _offset = Offset.zero;
    if(!firstPass){
      firstPass = true;
      if (_controller.value.initialized) {
        num newAspectRatio = widget.aspectRatio;
        return Stack(
            children: <Widget>[
            //https://medium.com/flutter-community/advanced-flutter-matrix4-and-perspective-transformations-a79404a0d828
              Transform(
                transform: Matrix4(
                  -1,0,0,0,
                  0,1,0,0,
                  0,0,-1,0,
                  0,0,0,1,
                ),
                alignment: FractionalOffset.center,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: newAspectRatio,
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
        return Container();
      }
    } else{
      if (widget.videoPath != null ){
        resetState();
      }
      return Container();
    }
  }
}