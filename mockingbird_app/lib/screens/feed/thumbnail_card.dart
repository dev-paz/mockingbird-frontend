import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:mockingbirdapp/screens/feed/view_video_screen.dart';
import 'package:mockingbirdapp/services/music_video_service.dart';


class ThumbnailCard extends StatefulWidget {
  String url;
  String created;
  String songId;
  String id;
  String ownerPhoto;
  String ownerName;
  String songName;
  String image;

  ThumbnailCard({ this.url, this.id, this.created, this.songId, this.ownerPhoto, this.songName, this.ownerName, this.image });

  @override
  _ThumbnailCardState createState() => _ThumbnailCardState();
}



class _ThumbnailCardState extends State<ThumbnailCard> {
  bool loading = true;
  String downloadURL;

  String username = 'cloud-admin';
  String password = 'UZTWLVEr6n';

  void  _initVideo() async {
    MusicVideoService mvService = MusicVideoService();
    downloadURL = await mvService.getDownloadURL(widget.url);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(size: 50.0) :
      GestureDetector(
        onTap: () async {
          await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewVideoScreen(
              url: widget.url,
              songId: widget.songId,
              created: widget.created,
              id: widget.id,
            )
            ),
          );
        },
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Image.network(widget.ownerPhoto,
                    height: 50,
                    width: 50,
                  ),
              ),
                title: Text(widget.songName,
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                subtitle: Text(widget.ownerName),
              ),
              Center(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: new Container(
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image: new NetworkImage(widget.image),
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
