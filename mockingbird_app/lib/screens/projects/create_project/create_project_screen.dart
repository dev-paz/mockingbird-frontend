import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/contants.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/models/song.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/projects/create_project/select_song_screen.dart';
import 'package:mockingbirdapp/services/project_service.dart';

import 'invite_friends_screen.dart';

class CreateProjectScreen extends StatefulWidget {

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  FocusNode projectNameFocus = new FocusNode();
  bool loading = false;

  String projectName = "";
  Song selectedSong;
  Map partsToUser;
  Map partsToUid;

  _showSongsList(BuildContext context) async {
    Song result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => SongsList()),
    );
    setState(() {
      selectedSong = result;
    });
  }

  _showFriendsList(BuildContext context, Song song) async {
    PopData result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => InviteFriendsScreen(song: song)),
    );
    setState(() {
      partsToUser = result.songPartToUser;
      partsToUid = result.partsToUids;
      print(partsToUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Create Project"),
      ),
      body: loading ? Loading(size: 50.0) : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.looks_one, color: Colors.pinkAccent, size: 35),
                      subtitle: Text("For example, 'My awesome Project'"),
                      title: Text("Name your project",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700]
                        ),
                        textAlign: TextAlign.center,
                        focusNode:projectNameFocus,
                        decoration: textInputDecoration.copyWith(hintText: "Type project name here",
                          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey)
                        ),
                        onChanged: (v){
                            setState(() {
                              projectName = v;
                            });
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                          Icons.looks_two,
                          color: projectName.length > 2 ? Colors.pinkAccent : Colors.grey,
                          size: 35
                      ),
                      subtitle: Text("Click below to choose a song"),
                      title: Text("Choose a song",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: selectedSong != null ? Text(selectedSong.title,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                              : Container(),
                        ),
                        SizedBox(width: 20),
                        RaisedButton.icon(
                            elevation: 4,
                            color: Colors.blue,
                            onPressed: projectName.length > 2 ? (){
                              _showSongsList(context);
                              projectNameFocus.unfocus();
                              } : null,
                            icon: Icon(Icons.music_note, color: Colors.white),
                            label: Text("Select Song",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                          Icons.looks_3,
                          color: selectedSong != null && projectName.length > 2 ? Colors.pinkAccent : Colors.grey,
                          size: 35),
                      subtitle: Text("Assign a friend to each dong part"),
                      title: Text("Invite Friends",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: selectedSong != null ?
                          singersPhotos(partsToUser) : Container(),
                        ),
                        SizedBox(width: 20),
                        RaisedButton.icon(
                            elevation: 4,
                            color: Colors.blue,
                            onPressed: selectedSong != null && projectName.length > 2 ?
                                (){_showFriendsList(context, selectedSong);} : null,
                            icon: Icon(Icons.people, color: Colors.white),
                            label: Text("Invite Friends",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                          Icons.looks_3,
                          color: projectName.length > 2 && selectedSong != null && partsToUser != null ? Colors.pinkAccent : Colors.grey,
                          size: 35),
                      subtitle: Text("You're ready to get singing!"),
                      title: Text("Create Project",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(),
                    RaisedButton.icon(
                        elevation: 4,
                        color: Colors.green,
                        onPressed: projectName.length > 2 && selectedSong != null && partsToUser != null ?
                        () async {
                          setState(() { loading = true; });
                          ProjectService ps = ProjectService();
                          dynamic resp = await ps.createProject(selectedSong.id, partsToUid, projectName);
                          if (resp != null){
                            print("create finished");
                            Navigator.pop(context);
                          }
                          setState(() { loading = false; });
                        } : null,
                        icon: Icon(Icons.done, color: Colors.white),
                        label: Text("Create Project",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget singersPhotos(Map selectedFriends){
  if (selectedFriends == null){
    return Container();
  }
  List<User> users = List();
  selectedFriends.forEach((k,v) => users.add(v));
  return Row(
    children: users.map((u) =>
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(u.picture,
              height: 30,
              width: 30,
            ),
          ),
        ),
    ).toList()
  );
}