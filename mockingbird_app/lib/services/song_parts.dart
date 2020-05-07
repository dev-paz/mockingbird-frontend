import 'package:http/http.dart';
import 'dart:convert';
import 'package:mockingbirdapp/models/song_part.dart';

class SongParts {

  List<SongPart> songParts = [];
  String songId;

  SongParts({ this.songId });

  Future<void> getSongParts() async {
    Response response = await get('https://mockingbird-backend.herokuapp.com/get_song_parts?id=$songId');
    List<dynamic> songsRsp = json.decode(response.body);
    for(var i=0; i < songsRsp.length; i++){
      SongPart songPart = SongPart(
          id: songsRsp[i]["id"],
          musicUrl: songsRsp[i]["music_url"],
          part: songsRsp[i]["part"],
          partType: songsRsp[i]["type"],
          aspectRatio: songsRsp[i]["aspect_ratio"].toDouble(),
          config: songsRsp[i]["config"]
      );
      songParts.add(songPart);
    }
  }
}
