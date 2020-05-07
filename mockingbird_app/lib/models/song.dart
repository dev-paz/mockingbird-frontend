import 'package:flutter/material.dart';

class Song{

  String id;
  String title;
  int difficulty;
  String parts;

  Song({ this.title, this.id, this.difficulty, this.parts });

  factory Song.fromJson(Map<String, dynamic> json) {
    int difficulty = json['difficulty'];
    return Song(
        title:json['title'],
        id: json['id'],
        difficulty: difficulty,
        parts: parseParts(json['parts'])
    );
  }
}

String parseParts(int parts){
  var partsString = parts.toString();
  assert(partsString is String);
  return partsString;
}