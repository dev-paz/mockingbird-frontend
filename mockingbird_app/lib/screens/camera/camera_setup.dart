import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/project_clip.dart';
import 'package:mockingbirdapp/models/song_part.dart';
import 'package:mockingbirdapp/screens/camera/video_timer.dart';
import 'package:mockingbirdapp/services/song_parts.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class CameraSetup extends StatefulWidget {
  final SongPart songPart;
  final int songLength;
  final ProjectClip currentClip;
  const CameraSetup({Key key, this.songPart, this.currentClip, this.songLength}) : super(key: key);

  @override
  CameraSetupState createState() => CameraSetupState();
}

class CameraSetupState extends State<CameraSetup> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _timerKey = GlobalKey<VideoTimerState>();
  VideoPlayerController _videoController;
  CameraController _controller;
  List<CameraDescription> _cameras;
  bool _isRecording = false;
  String clipFilePath;
  bool fileDownloading = true;

  Project currentProject;

  @override
  void initState() {
    currentProject = Provider.of<Project>(context, listen:false);
    _initCamera();
    _initKaraokeVideo();
    super.initState();
  }

  _initKaraokeVideo() async {
    SongParts songPartService = SongParts();
    String filePath = await songPartService.downloadSongPart(widget.songPart.musicUrl, "karaoke_video");
    _videoController = VideoPlayerController.file(File(filePath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          fileDownloading = false;
        });
      });
  }

  Future<void> _initCamera() async {
    clipFilePath = await widget.currentClip.getLocalFilePath();
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[1], ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      extendBody: true,
      body: fileDownloading ? Loading() : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min  ,
          children: <Widget>[
            !_videoController.value.initialized ? Container() :
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
            Stack(
              children: <Widget>[
                _buildCameraPreview(),
                _isRecording ?  Container() : Positioned(
                  left: 0,
                  right: 0,
                  bottom: 64,
                  child: Center(
                    child: RaisedButton.icon(
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                        child: Icon(Icons.star,
                        color: Colors.white),
                      ),
                      onPressed: (){
                        startVideoRecording(clipFilePath);
                      },
                      color: Colors.red,
                      label: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        child: Text("Start recording",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 32.0,
                  child: VideoTimer(
                    key: _timerKey,
                    songLength: widget.songLength,
                    stopRecording: () async {
                      stopVideoRecording();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    num newAspectRatio = widget.songPart.aspectRatio;
    return Container(
        child: AspectRatio(
            aspectRatio: newAspectRatio,
            child: ClipRect(
                child: Transform.scale(
                  scale:  newAspectRatio /_controller.value.aspectRatio ,
                  child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller)
                      ),
                  )
                ),
            ),
            ),
    );
  }


  Future<String> startVideoRecording(filePath) async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    _deleteFile(filePath);
    _timerKey.currentState.startTimer();

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      if (e.code == "fileExists") {
      }
      return null;
    }
    setState(() {
      _videoController.play();
    });
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    _timerKey.currentState.stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      await _controller.stopVideoRecording();
      _controller.dispose();
      Navigator.pop(context);

    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}

_deleteFile(currentFilePath) {
  try {
    final dir = Directory(currentFilePath);
    dir.deleteSync(recursive: true);
    print('deleted a file');
  }catch(e){
    print("no file here to delete");
  }

}