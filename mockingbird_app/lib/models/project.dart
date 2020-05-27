import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mockingbirdapp/models/project_clip.dart';
import 'package:mockingbirdapp/models/song.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'dart:convert';
import 'package:dio/dio.dart';


class Project with ChangeNotifier {

  final String uname = 'cloud-admin';
  final String password = 'UZTWLVEr6n';
  final String url = 'http://3.80.246.206';

  final int PROJECT_STATUS_STARTED = 1;
  final int PROJECT_STATUS_RENDERING = 2;
  final int PROJECT_STATUS_UPLOADING = 3;
  final int PROJECT_STATUS_COMPLETED = 4;

  String name = "";
  String id;
  Song song;
  String filePath;
  int openshotId;
  String status;
  List<User> users;
  List<ProjectClip> clips;
  String exportId;

  Project({
    this.name,
    this.id,
    this.song,
    this.openshotId,
    this.users, this.clips,
    this.status,
    this.exportId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        name: json['name'],
        id: json['id'],
        status: json['status'],
        exportId: json["export_id"],
        song: parseSong(json['song']),
        clips: parseClips(json['clips']),
        openshotId: int.parse(json["openshot_id"]),
    );
  }

  Map<String, dynamic> toJson(){
    List<Map<String, dynamic>> clipsJson = [];
    clips.map((clip) => clipsJson.add(clip.toJson())).toList();

    Map<String, dynamic> projectJson = {
      'name': name,
      'id': id,
      'song': {
        "id": song.id,
        "difficulty": song.difficulty,
        "title": song.title,
        "parts": int.parse(song.parts),
        "length_seconds": song.length,
        "backing_track": song.backingTrack
      },
      "openshot_id": "$openshotId",
      "clips": clipsJson
    };
    return projectJson;
  }

  static parseClips(clipsJson) {
    var list = clipsJson as List;
    List<ProjectClip> clipList =
    list.map((data) => ProjectClip.fromJson(data)).toList();
    return clipList;
  }

  static Song parseSong(songJson) {
    Song song = new Song.fromJson(songJson);
    return song;
  }

  static List<User> parseUsers(usersJson) {
    var list = usersJson as List;
    List<User> usersList =
    list.map((data) => User.fromJson(data)).toList();
    return usersList;
  }

  Future<dynamic> renderProject() async {
    var headers = {"Content-Type": "application/json"};
    Map<String, dynamic> body = this.toJson();
    http.Response response = await http.post('https://mockingbird-backend.herokuapp.com/render_video',
        body: jsonEncode(body),
        headers: headers
    );
    if (response.statusCode == 200){
      return response;
    }
    return null;
  }

  Future<bool> deleteProject() async{
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode(
        { "project_id": id }
    );
    http.Response response = await http.post('https://mockingbird-backend.herokuapp.com/delete_project',
        body: body,
        headers: headers
    );
    if (response.statusCode == 200){
      return true;
    }
    return false;
  }

  Future<double> checkRenderStatus() async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$uname:$password'));
    Dio dio = new Dio();
    dio.options.headers['Authorization'] = basicAuth;
    try {
      Response openshotRps = await dio.get(url + "/exports/" + exportId + "/");
      double progress = openshotRps.data["progress"];
      return progress;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteProjectDialog(BuildContext context, Function closeScreen) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete project'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this project?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('DELETE',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
              ),
              onPressed: () async {
                bool ok = await deleteProject();
                if (!ok){
                  print("error deleting project");
                }
                closeScreen();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
