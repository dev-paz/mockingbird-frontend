import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {

  String name;
  String photo;
  Function inviteFriend;

  UserCard({ this.name, this.photo, this.inviteFriend });


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(photo,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  title: Text(name,
                    style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  subtitle: Text("Pro singer"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 8),
                child: RaisedButton.icon(
                  color: Colors.blue,
                  icon: Icon(Icons.mail, color: Colors.white, size: 16,),
                  onPressed: (){
                    inviteFriend();
                  },
                  label: Text("Invite",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
