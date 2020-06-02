import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/audio_player.dart';
import 'package:mockingbirdapp/models/project.dart';

Widget titleCard(List<Widget> stars, bool projectReady, Function _renderProject, Project project){
  return Card(
    elevation: 0,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.headset, color: Colors.pink, size: 35),
            subtitle: Text("This is the song you'll be re creating!"),
            title: Text(project.song.title,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          //AudioPlayer(),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Difficulty(stars),
                Parts("2")
              ],
            ),
          ),
          SizedBox(height: 32),
          RaisedButton(
            onPressed: projectReady ? (){
              _renderProject();
            } : null,
            color: Colors.green,
            child: Text("Finish Project",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ),
  );
}


Widget Difficulty(List<Icon> stars) {
  return Row(
      children: <Widget>[
        Text("Difficulty",
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(width: 16),
        Row(
            children: stars
        )
      ]
  );
}

Widget Parts(String parts) {
  return Row(
      children: <Widget>[
        Icon(Icons.people),
        SizedBox(width: 10),
        Text(parts)
      ]
  );
}