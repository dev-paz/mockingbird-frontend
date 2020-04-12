import 'package:flutter/material.dart';
import 'package:mockingbirdapp/screens/home.dart';

class ProjectCard extends StatelessWidget {

  String title;
  String songName;
  final NavigationCallback onCardPressed;


  ProjectCard({ this.title, this.songName, this.onCardPressed });


   @override
   Widget build(BuildContext context) {
     return  Center(
       child: Card(
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: <Widget>[
            ListTile(
               leading: Icon(Icons.music_note),
               title: Text(title),
               subtitle: Text(songName),
             ),
             ButtonBar(
               children: <Widget>[
                 FlatButton(
                   child: const Text('EDIT PROJECT'),
                   onPressed: () {
                     onCardPressed();
                     },
                 ),
               ],
             ),
           ],
         ),
       ),
     );
   }
 }
