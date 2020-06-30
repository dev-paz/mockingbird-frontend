import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mockingbirdapp/models/song_part.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class SongParts {

  List<SongPart> songParts = [];
  String songId;

  SongParts({ this.songId });

  Future<void> getSongParts() async {
    http.Response response = await http.get('https://mockingbird-backend.herokuapp.com/get_song_parts?id=$songId');
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


  Future<String> downloadSongPart(String url, String fileName) async {
    Dio dio = new Dio();
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    try{
      await dio.download(url, '$dirPath/$fileName.mp4');
    } catch(e){
      print(e);
    }
    return '$dirPath/$fileName.mp4';
  }
}

