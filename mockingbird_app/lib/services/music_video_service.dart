import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/music_video.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';


class MusicVideoService {

  final StorageReference storageReference = FirebaseStorage().ref();

  Future<List<MusicVideo>> getAllMusicVideos() async {
    List<MusicVideo> musicVideos = [];
    Response response;
    try {
      response = await get('https://mockingbird-backend.herokuapp.com/get_music_videos');
    } catch (e) {
      print(e);
      return null;
    }
    List<dynamic> mvResp = json.decode(response.body);
    if (mvResp == null){
      return musicVideos;
    }
    for(var i=0; i < mvResp.length; i++){
      MusicVideo mv = new MusicVideo.fromJson(mvResp[i]);
      musicVideos.add(mv);
    }
    return musicVideos;
  }


  Future<MusicVideo> getMusicVideo(String musicVideoID) async {
    Response response;
    try {
      print(musicVideoID);
      response = await get('https://mockingbird-backend.herokuapp.com/get_music_video?id='+ musicVideoID);
    } catch (e) {
      print(e);
      return null;
    }
    dynamic mvResp = json.decode(response.body);
    MusicVideo musicVideo = MusicVideo.fromJson(mvResp);
    return musicVideo;
  }


  Future<String> getDownloadURL(String fileName) async {
    String downloadURL = await storageReference.child(fileName).getDownloadURL();
    return downloadURL;
  }

  Future<dynamic> makePublic(String musicVideoID) async {
    Response response = await post('https://mockingbird-backend.herokuapp.com/post_music_video?id=' + musicVideoID);
    if (response.statusCode == 200){
      return response;
    }
    return null;
  }


  Future<void> postMusicVideoDialog(BuildContext context, String musicVideoID, Function reload) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post video'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will make your video visible to everyone on the main feed'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('POST',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
              ),
              onPressed: () async {
                await makePublic(musicVideoID);
                Navigator.of(context).pop();
                reload();
              },
            ),
          ],
        );
      },
    );
  }
}