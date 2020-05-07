//import 'dart:io';
//import 'package:path_provider/path_provider.dart';
//import 'package:flutter/material.dart';
//
//
//class ProjectStateProvider  with ChangeNotifier {
//  String currentProjectID;
//  String filePath;
//  String username = 'cloud-admin';
//  String password = 'UZTWLVEr6n';
//  num counter = 0;
//
//
//  ProjectStateProvider({ this.currentProjectID });
//
//  void updateFilePath() {
//    print("update file path");
//    counter = counter + 1;
//    notifyListeners();
//  }
//
//
//  Future<void> setProjectFilePath() async {
//    final Directory extDir = await getApplicationDocumentsDirectory();
//    final String dirPath = '${extDir.path}/media';
//    await Directory(dirPath).create(recursive: true);
//    filePath = '$dirPath/${currentProjectID}.mp4';
//  }
//}
