import 'dart:ffi';

class SongPart{
  int part;
  String musicUrl;
  String partType;
  String id;
  String songId;
  double aspectRatio;
  String config;

  SongPart({ this.part, this.musicUrl, this.partType, this.id, this.songId, this.aspectRatio, this.config });
}