import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/audio_player.dart';
import 'package:mockingbirdapp/models/user.dart';

// ignore: must_be_immutable
class SongPartCard extends StatelessWidget {

  String musicUrl;
  int part;
  Function showFriendsList;
  String partType;
  User currentUser;

  SongPartCard({ this.musicUrl, this.part, this.showFriendsList, this.partType, this.currentUser });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Part $part: $partType",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 12, 8),
                child: AudioPlayer(),
              ),
              Padding(
                padding: EdgeInsets.only(right: 24),
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    showSelectedUser(currentUser),
                    RaisedButton(
                      onPressed: (){showFriendsList();},
                      color: Colors.blue,
                      padding: EdgeInsets.all(12),
                      child: Text("Select Singer",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget showSelectedUser(User currentUser){
  if (currentUser != null){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(currentUser.picture,
              height: 30,
              width: 30,
            ),
          ),
          SizedBox(width: 12),
          Text(currentUser.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,

            ),
          )
        ],
      ),
    );
  }
  return Container();
}
