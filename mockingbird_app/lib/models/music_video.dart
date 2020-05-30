import 'package:http/http.dart';
import 'package:mockingbirdapp/models/project_clip.dart';

class MusicVideo {
  String id;
  String url;
  String songId;
  String created;
  String owner;
  String ownerName;
  String ownerPhoto;
  String songTitle;
  List<ProjectClip> clips;
  String albumArt;
  bool public;


  MusicVideo({ this.id, this.created, this.songId, this.url, this.owner, this.ownerPhoto, this.songTitle, this.ownerName, this.clips, this.albumArt, this.public });

  factory MusicVideo.fromJson(Map<String, dynamic> json) {
    return MusicVideo(
      id: json["id"],
      url: json["url"],
      songId: json["song_id"],
      created: json["created"],
      owner: json["owner"],
      ownerName: json["owner_name"],
      ownerPhoto: json["owner_photo"],
      songTitle: json["title"],
      clips: parseClips(json['clip']),
      albumArt: json["album_art"],
      public: json["public"]
    );
  }

  static parseClips(clipsJson) {
    var list = clipsJson as List;
    List<ProjectClip> clipList =
    list.map((data) => ProjectClip.fromJson(data)).toList();
    return clipList;
  }
}