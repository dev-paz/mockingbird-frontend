import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/project_clip.dart';

Widget friendsPartsCard(ProjectClip projectClip){
  return Card(
    elevation: 0,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(projectClip.picture,
                height: 40,
                width: 40,
              ),
            ),
            subtitle: projectClip.file == "" ? Text("Waiting to submit recording") : Text("Recording done"),
            title: Text("Lead vocals 1",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
        ],
      ),
    ),
  );
}