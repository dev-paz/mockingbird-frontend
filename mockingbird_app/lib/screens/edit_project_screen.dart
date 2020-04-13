import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockingbirdapp/camera/video_preview.dart';
import 'package:mockingbirdapp/models/ProjectStateProvider.dart';
import 'package:provider/provider.dart';

class EditProject extends StatefulWidget {

  @override
  _EditProjectState createState() => _EditProjectState();
}


class _EditProjectState extends State<EditProject> {

  _deleteFile(filePath) {
    try {
      final dir = Directory(filePath);
      dir.deleteSync(recursive: true);
      print('deleted a file');
      setState(() {});
    }catch(e){
      print("no file here to delete");
    }
  }


@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final projectStateProvider = Provider.of<ProjectStateProvider>(context);
    print("rebuilding compnent!");
    return  Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Edit Project '),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 8, 16),
                child: Text("Mockingbird",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    color: Colors.grey[800]
                  ),
                ),
              ),
              VideoPreview(
                videoPath: projectStateProvider.filePath,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.videocam),
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                      onPressed: (){
                        Navigator.pushNamed(context, '/camera');
                        _deleteFile(projectStateProvider.filePath);},
                      label: Text("Record",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(width: 2.0),
                    RaisedButton.icon(
                      icon:Icon(Icons.cloud_upload),
                      color: Colors.blue,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      splashColor: Colors.blueAccent,
                      onPressed: null,
                      label: Text("Upload",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 120, 12, 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.blueAccent,
                        splashColor: Colors.blueAccent,
                        elevation: 4,
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
                        child: Text("Export Project",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: null,
                      ),
                  ),]
                ),
              )
            ],
          ),
        )
    );
  }

}
