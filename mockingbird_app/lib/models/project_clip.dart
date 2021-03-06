import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ProjectClip {

  final String id;
  final String songId;
  final String projectId;
  final String userId;
  final String partId;
  final String file;
  final String openshotProjectId;
  final String openshotProjectURL;
  final String status;
  final String username;
  final String picture;
  final String partType;
  final String length;
  String platform;
  Function updateProgressIndicator;

  ProjectClip (
      {
        this.id,
        this.songId,
        this.projectId,
        this.userId,
        this.partId,
        this.file,
        this.openshotProjectId,
        this.openshotProjectURL,
        this.status,
        this.picture,
        this.username,
        this.updateProgressIndicator,
        this.partType,
        this.platform,
        this.length
      }
    );

  factory ProjectClip.fromJson(Map<String, dynamic> json) {
    return ProjectClip(
        id: json["id"],
        songId: json["song_id"],
        projectId: json["project_id"],
        userId: json["user_id"],
        partId: json["part_id"],
        file: json["file"],
        openshotProjectId: json["openshot_project_id"],
        status: json["status"],
        username: json["username"],
        picture: json["profile_photo_url"],
        partType: json["part_type"],
        platform: json["platform"],
        length: json["length"]
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> userJson = {
      "id": id,
      "song_id": songId,
      "project_id": projectId,
      "user_id": userId,
      "part_id": partId,
      "file": file,
      "openshot_id": openshotProjectId,
      "openshot_url": openshotProjectURL,
      "status": status,
      "platform": platform,
      "length":length
    };
    return userJson;
  }

  Future<String> getLocalFilePath() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    print('sdkjwepfj');
    print('$dirPath/${id}.mp4');
    return '$dirPath/${id}.mp4';
  }

  Future<bool> uploadFileToProject(filePath) async {

    http.Response response = await http.get('https://mockingbird-backend.herokuapp.com/get_ip');
    String ip = json.decode(response.body);
    print("http://" + ip + "/projects/" + openshotProjectId + "/");
    MultipartFile file = await MultipartFile.fromFile(filePath, filename: id+".mp4");
    FormData formData = new FormData.fromMap({
      "json": "{}",
      "project": "http://" + ip + "/projects/" + openshotProjectId + "/",
      "media": file
    });

    Dio dio = new Dio();
    try {
      Response openshotRps = await dio.post("https://mockingbird-backend.herokuapp.com/upload_video",
        data: formData,
        onSendProgress: (int sent, int total) {
          updateProgressIndicator(sent/total);
        },
      );

      if (Platform.isAndroid) {
        platform = "android";
      } else if (Platform.isIOS) {
        platform = "ios";
      }

      var headers = {"Content-Type": "application/json"};
      var body = jsonEncode(
          {
            'id': id,
            'file': openshotRps.data["url"],
            'platform': platform
          }
      );
      print(body);
      http.Response response = await http.post('https://mockingbird-backend.herokuapp.com/update_clip',
          body: body,
          headers: headers
      );
      if (response.statusCode == 200){
        return true;
      }

      return true;
    } catch(e){
      print(e);
      return false;
    }
  }
}