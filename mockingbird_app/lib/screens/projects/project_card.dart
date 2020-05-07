import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mockingbirdapp/models/project.dart';
import 'package:mockingbirdapp/models/project_clip.dart';


class ProjectCard extends StatelessWidget {

  Project project;

  final Function onCardPressed;
  ProjectCard({ this.project, this.onCardPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
          child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text(project.name),
                  subtitle: Text(project.song.title),
                ),
                Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    singersPhotos(project.clips),
                    SizedBox(width: 16),
                    FlatButton(
                      child: const Text('EDIT PROJECT',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        onCardPressed();
                      },
                    ),
                  ],
                ),
                ),
              ],
            );
          }
        )
      )
    );
  }
}

Widget singersPhotos(List<ProjectClip> clips){
  if (clips == null){
    return Container();
  }
  return Row(
      children: clips.map((c) =>
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(c.picture,
                height: 30,
                width: 30,
              ),
            ),
          ),
      ).toList()
  );
}