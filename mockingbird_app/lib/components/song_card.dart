import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/audio_player.dart';

class SongCard extends StatefulWidget {

  String id;
  String title;
  int difficulty;
  String parts;
  final Function onCardPressed;

  SongCard({ this.title, this.id, this.difficulty, this.parts, this.onCardPressed});

  @override
  _SongCardState createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  List<Icon> stars = [];

  setupStars(){
    for(var i = 0; i < widget.difficulty; i++ ) {
      stars.add(Icon(Icons.star, color: Colors.pink, size: 20));
    }

    for(var i = 0; i < 5 - widget.difficulty; i++ ) {
      stars.add(Icon(Icons.star, color: Colors.grey, size: 20));
    }
  }

  @override
  void initState() {
    super.initState();
    setupStars();
  }

  @override
  Widget build(BuildContext context) {

    return  Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text(widget.title,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              AudioPlayer(),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Difficulty(stars),
                    Parts(widget.parts)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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