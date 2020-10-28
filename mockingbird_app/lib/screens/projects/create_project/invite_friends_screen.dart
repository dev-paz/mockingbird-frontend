import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/components/song_part_card.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/song.dart';
import 'package:mockingbirdapp/models/song_part.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/screens/projects/create_project/friends_list_screen.dart';
import 'package:mockingbirdapp/services/song_parts.dart';

class InviteFriendsScreen extends StatefulWidget {
  Song song;
  InviteFriendsScreen({ this.song });

  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {

  Map songPartToUser = Map<String, User>();
  Map partsToUids =  Map<String, String>();

  _showFriendsList(BuildContext context, String id) async {
    User user = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => FriendsListScreen()),
    );
    setState(() {
      songPartToUser[id] = user;
      partsToUids[id] = user.firebaseUserId;
    });
  }

  Project project;
  List<SongPart> songParts;
  bool loading = true;

  _fetchSongParts() async {

    if (widget.song.id != "song_c34e63dc-76c4-4755-b87c-4972012fc4e2"){
      SongParts instance = SongParts(
          songId: widget.song.id
      );
      await instance.getSongParts();

      setState(() {
        songParts = instance.songParts;
        loading = false;
      });
    } else {
      print("hellowqrger");
      List<SongPart> freestyleSongParts = List<SongPart>();
      print(widget.song.parts);
      for (var i = 1; i <= double.parse(widget.song.parts); i++){
        SongPart sp = SongPart(
          songId: widget.song.id,
          part: i,
          partType: "",
          musicUrl: "",
          id: "freestyle_" + i.toString()
        );
        freestyleSongParts.add(sp);
      }
      setState(() {
        songParts = freestyleSongParts;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSongParts();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("Select your co-singers"),
          ),
          body: loading ? Loading(size: 50.0) : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.info),
                          subtitle: Text(
                              "Listen to each part of the song and choose a singer for each. "
                                  "Click here when you're done!",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 16),
                          RaisedButton(
                            child: const Text("I'm done!",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                            color: Colors.green,
                            onPressed: songPartToUser.length.toString() == widget.song.parts ?
                              (){
                                PopData data = PopData(
                                  songPartToUser: songPartToUser,
                                  partsToUids: partsToUids
                                );
                                Navigator.pop(context, data);
                              } : null
                          ),
                        ],

                    ),
                  ),
                ),
                Column(
                  children: songParts.map((sp) =>
                      SongPartCard(
                        showFriendsList: (){_showFriendsList(context, sp.id);},
                        musicUrl: sp.musicUrl,
                        part: sp.part,
                        partType: sp.partType,
                        currentUser: songPartToUser.containsKey(sp.id) ? songPartToUser[sp.id] : null
                      )
                  ).toList(),
                ),
              ],
            )
            ),
        );
      }
    );
  }
}

class PopData{
  Map songPartToUser;
  Map partsToUids;
  PopData({ this.songPartToUser, this.partsToUids });
}
