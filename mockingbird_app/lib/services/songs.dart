import 'package:http/http.dart';
import 'dart:convert';

import 'package:mockingbirdapp/models/song.dart';

class Songs {

  Future<List<Song>> getSongs() async {
    List<Song> songs = [];
    Response response = await get('https://mockingbird-backend.herokuapp.com/get_songs');
    List<dynamic> songsRsp = json.decode(response.body);
    for(var i=0; i < songsRsp.length; i++){
      Song song = new Song.fromJson(songsRsp[i]);
      songs.add(song);
    }
    return songs;
  }
}
