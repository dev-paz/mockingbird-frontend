import 'package:mockingbirdapp/models/music_video.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';


class MusicVideoService {

  final StorageReference storageReference = FirebaseStorage().ref();

  Future<List<MusicVideo>> getMusicVideos() async {
    List<MusicVideo> musicVideos = [];
    try {
      Response response = await get('https://mockingbird-backend.herokuapp.com/get_music_videos');
      List<dynamic> mvResp = json.decode(response.body);
      if (mvResp == null){ return null; }
      for(var i=0; i < mvResp.length; i++){
        MusicVideo mv = MusicVideo(
          id: mvResp[i]["id"],
          url: mvResp[i]["url"],
          song_id: mvResp[i]["song_id"],
          created: mvResp[i]["created"],
          owner: mvResp[i]["owner"],
          owner_name: mvResp[i]["owner_name"],
          owner_photo: mvResp[i]["owner_photo"],
          song_title: mvResp[i]["title"],
        );
        musicVideos.add(mv);
      }
      return musicVideos;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getDownloadURL(String fileName) async {
    String downloadURL = await storageReference.child(fileName).getDownloadURL();
    return downloadURL;
  }
}