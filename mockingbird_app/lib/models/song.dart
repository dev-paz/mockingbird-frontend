import 'package:flutter/material.dart';

class Song{

  String id;
  String title;
  int difficulty;
  String parts;
  int length;
  String backingTrack;
  String tempo;

  Song({ this.title, this.id, this.difficulty, this.parts, this.length, this.backingTrack, this.tempo });

  factory Song.fromJson(Map<String, dynamic> json) {
    int difficulty = json['difficulty'];
    int length = json['length_seconds'];
    return Song(
        title:json['title'],
        id: json['id'],
        length: length,
        difficulty: difficulty,
        parts: parseParts(json['parts']),
        backingTrack: json['backing_track'],
        tempo: json['tempo']
    );
  }
}

String parseParts(int parts){
  var partsString = parts.toString();
  assert(partsString is String);
  return partsString;
}

