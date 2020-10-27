import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/components/song_card.dart';
import 'package:mockingbirdapp/models/song.dart';
import 'package:mockingbirdapp/services/songs.dart';
import 'package:mockingbirdapp/screens/projects/create_project/freestyle_card.dart';

class SongsList extends StatefulWidget {
  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {

  bool loading = true;
  List<Song> songs = [];
  Song freestyleSong;

  getBackendSongs() async {
    setState(() {
      loading = true;
    });
    Songs instance = Songs();
    songs = await instance.getSongs();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBackendSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a song'),
      ),
        backgroundColor: Colors.grey[200],
        body: loading ? Loading(size: 100.0) : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FreestlyeCard(

              ),
              Column(
                children: songs.map((s) => new InkWell(
                  onTap: () async {
                    Navigator.pop(context, s);
                  },
                  child: SongCard(
                    title: s.title,
                    id: s.id,
                    difficulty: s.difficulty,
                    parts: s.parts,
                  ),
                )).toList(),
                ),
            ],
          ),
        ),
    );
  }
}

typedef NavigationCallback = void Function();
