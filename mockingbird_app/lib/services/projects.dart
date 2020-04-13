import 'package:http/http.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'dart:convert';
import 'package:mockingbirdapp/components/project_card.dart';

class Projects {

  List<Project> projects = [];

  Future<void> getProjects() async {
    Response response = await get('https://mockingbird-backend.herokuapp.com/get_projects');
    List<dynamic> projectsResp = json.decode(response.body);
    print(projectsResp);
    for(var i=0; i < projectsResp.length; i++){
      Project project = Project(
          name: projectsResp[i]["name"],
          song: projectsResp[i]["song"],
          id: projectsResp[i]["id"],
          openshotId: projectsResp[i]["openshot_id"]
      );
      projects.add(project);
    }
  }
}

