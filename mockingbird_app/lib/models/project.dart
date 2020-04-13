import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Project {

   String name;
   String id;
   String song;
   String username = 'cloud-admin';
   String password = 'UZTWLVEr6n';
   String filePath;
   int openshotId;

   Project({ this.name, this.id, this.song , this.openshotId});


   Future<void> uploadFileToProject() async {
     FormData formData = new FormData.fromMap({
       "json": "{}",
       "project": "http://54.197.222.177/projects/20/",
       "media": await MultipartFile.fromFile(filePath, filename: "upload.mp4")
     });
     String basicAuth =
         'Basic ' + base64Encode(utf8.encode('$username:$password'));

     Dio dio = new Dio();
     dio.options.headers['Authorization'] = basicAuth;
     try {
       Response response = await dio.post(
           "http://54.197.222.177/files/", data: formData);
       print(response);

     } catch(e){
       print(e);
     }
   }

   Future<void> setProjectFilePath() async {
     final Directory extDir = await getApplicationDocumentsDirectory();
     final String dirPath = '${extDir.path}/media';
     await Directory(dirPath).create(recursive: true);
     filePath = '$dirPath/${id}.mp4';
   }
}