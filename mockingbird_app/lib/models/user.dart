import 'package:http/http.dart';
import 'dart:convert';
import 'package:mockingbirdapp/models/project.dart';

class User {

  final String firebaseUserId;
  final String picture;
  final String name;
  final String idToken;
  List<User> friends = [];
  List<Project> projects;

  User(
        {
          this.firebaseUserId,
          this.name,
          this.picture,
          this.idToken
        }
      );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firebaseUserId: json["firebase_user_id"],
        picture: json["profile_photo_url"],
        name: json["name"],
        idToken: json["id_token"]
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> userJson = {
      "firebase_user_id": firebaseUserId,
      "picture": picture,
      "name": name,
      "id_token": idToken
    };
    return userJson;
  }

  Future<void> getFriends() async {
    List<User> friendsList = [];
    Response response = await get('https://mockingbird-backend.herokuapp.com/get_all_users');
    List<dynamic> songsRsp = json.decode(response.body);
    for(var i=0; i < songsRsp.length; i++){
      User user = User(
        firebaseUserId: songsRsp[i]["firebase_user_id"],
        name: songsRsp[i]["name"],
        picture: songsRsp[i]["profile_photo_url"],
      );
      friendsList.add(user);
    }
    friends = friendsList;
  }

  Future<bool> getAllProjects() async {
    List<Project> projectsList = [];
    Response response;
    print(firebaseUserId);

    try {
      response = await get('https://mockingbird-backend.herokuapp.com/get_all_projects?user_id=' + firebaseUserId);
    }catch (e) {
      print(e);
      projects = null;
      return false;
    }
    List<dynamic> projectsResp = json.decode(response.body);
    if (projectsResp == null){
      projects = projectsList;
      return true;
    }
    for(var i=0; i < projectsResp.length; i++){
      Project project = new Project.fromJson(projectsResp[i]);
      projectsList.add(project);
    }
    projects = projectsList;
    print("oiyg");
    print(projectsList[0].name);
    return true;
  }
}