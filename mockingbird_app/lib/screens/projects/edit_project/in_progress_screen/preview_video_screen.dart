import 'package:flutter/material.dart';
import 'package:mockingbirdapp/screens/camera/video_preview.dart';

class PreviewVideoScreen extends StatefulWidget {
  String file;
  double aspectRatio;
  PreviewVideoScreen({ this.file, this.aspectRatio });
  @override
  _PreviewVideoScreenState createState() => _PreviewVideoScreenState();
}

class _PreviewVideoScreenState extends State<PreviewVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        child: VideoPreview(videoPath: widget.file, aspectRatio: widget.aspectRatio),
      ),
    );
  }
}
