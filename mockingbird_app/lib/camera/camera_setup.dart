import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockingbirdapp/camera/video_timer.dart';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:provider/provider.dart';

class CameraSetup extends StatefulWidget {
  const CameraSetup({Key key}) : super(key: key);

  @override
  CameraSetupState createState() => CameraSetupState();
}

class CameraSetupState extends State<CameraSetup>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRecordingMode = true;
  bool _isRecording = false;
  final _timerKey = GlobalKey<VideoTimerState>();


  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
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
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
          Positioned(
            top: 24.0,
            left: 12.0,
            child: IconButton(
              icon: Icon(
                Icons.switch_camera,
                color: Colors.black,
              ),
              onPressed: () {
                _onCameraSwitch();
              },
            ),
          ),
          if (_isRecordingMode)
            Positioned(
              left: 0,
              right: 0,
              top: 32.0,
              child: VideoTimer(
                key: _timerKey,
              ),
            )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCameraPreview() {
    num newAspectRatio = 4/3;

    return Container(
        child: Center(
          child: AspectRatio(
              aspectRatio: 4/3,
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
        ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<ProjectStateProvider>(
      builder: (context, providerState, child) {
          return Container(
            color: Theme.of(context).bottomAppBarColor,
            height: 100.0,
            width: double.infinity,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 28.0,
              child: IconButton(
                icon: Icon(
                  (_isRecordingMode)
                      ? (_isRecording) ? Icons.stop : Icons.videocam
                      : Icons.camera_alt,
                  size: 30.0,
                  color: (_isRecording) ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  if (!_isRecordingMode) {
                    _captureImage();
                  } else {
                    if (_isRecording) {
                      stopVideoRecording();
                      providerState.updateFilePath();
                    } else {
                      startVideoRecording(providerState.filePath);
                    }
                  }
                },
              ),
            ),
          );
      },
    );
  }

  Future<FileSystemEntity> getLastImage() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    var lastFile = _images[0];
    var extension = path.extension(lastFile.path);
    if (extension == '.jpeg') {
      return lastFile;
    } else {
      String thumb = await Thumbnails.getThumbnail(
          videoFile: lastFile.path, imageType: ThumbFormat.PNG, quality: 30);
      return File(thumb);
    }
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() async {
    print('_captureImage');
    if (_controller.value.isInitialized) {
      SystemSound.play(SystemSoundType.click);
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      await _controller.takePicture(filePath);
      setState(() {});
    }
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

//    final Directory extDir = await getApplicationDocumentsDirectory();
//    final String dirPath = '${extDir.path}/media';
//    await Directory(dirPath).create(recursive: true);
//    final String filePath = '$dirPath/${providerState.}.mp4';
//    print("File path");
//    print(filePath);

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      if (e.code == "fileExists") {
        print("made it here!!!!!!!!!!");
      }
      return null;
    }
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

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

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