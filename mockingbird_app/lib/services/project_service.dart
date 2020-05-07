import 'package:http/http.dart' as http;
import 'package:mockingbirdapp/models/project.dart';
import 'dart:convert';
import 'package:mockingbirdapp/models/project_clip.dart';

class ProjectService {

  String username = 'cloud-admin';
  String password = 'UZTWLVEr6n';
  String url = 'http://54.208.170.167';

  String projectId;
  Project project;
  List<Project> projects = [];
  ProjectClip clip;

  ProjectService({ this.projectId, this.project});

  void printWrapped(String text) {
    final pattern = RegExp('.{2,1000}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<dynamic> createProject(String songId, Map partsToUids, String name) async {
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode(
          { 'song_id': songId,
            'name': name,
            'clips_to_users': partsToUids,
          }
        );
    http.Response response = await http.post('https://mockingbird-backend.herokuapp.com/create_project',
      body: body,
      headers: headers
    );
    if (response.statusCode == 200){
      return response;
    }
    return null;
  }

  Future<Project> getProject() async {
    http.Response response;
    try {
      response = await http.get('https://mockingbird-backend.herokuapp.com/get_project?id='+ projectId);
    }catch (e) {
      print(e);
      return null;
    }
    dynamic projectsResp = json.decode(response.body);
    if (projectsResp == null){
      return null;
    }
    Project project = new Project.fromJson(projectsResp);
    return project;
  }

}

