import 'package:flutter/material.dart';
import 'package:mockingbirdapp/models/project_clip.dart';

class CompletedPartsCard extends StatefulWidget {
  ProjectClip projectClip;
  CompletedPartsCard({ this.projectClip });
  @override
  _CompletedPartsCardState createState() => _CompletedPartsCardState();
}

class _CompletedPartsCardState extends State<CompletedPartsCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(widget.projectClip.picture,
                  height: 40,
                  width: 40,
                ),
              ),
              subtitle: Text("This is the song you'll be re creating!"),
              title: Text("Lead vocals 1",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("You're all done!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.thumb_up, color: Colors.green)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


