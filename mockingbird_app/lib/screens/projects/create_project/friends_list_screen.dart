import 'package:flutter/material.dart';
import 'package:mockingbirdapp/components/user_card.dart';
import 'package:mockingbirdapp/models/user.dart';
import 'package:mockingbirdapp/components/loading.dart';
import 'package:provider/provider.dart';

class FriendsListScreen extends StatefulWidget {

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {

  bool loading = true;
  List<User> friends = [];
  User currentUser;

  getFriendsFromBackend() async {
    setState(() {
      loading = true;
    });
    currentUser = Provider.of<User>(context, listen: false);
    await currentUser.getFriends();
    setState(() {
      loading = false;
      friends = currentUser.friends;
    });
  }

  inviteFriend(User user){
    print("made it here");
    print(user.name);
    Navigator.pop(context, user);
  }

  @override
  void initState() {
    super.initState();
    getFriendsFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      backgroundColor: Colors.grey[200],
      body: loading ? Loading(size: 100.0) : SingleChildScrollView(
        child: Column(
          children: friends.map((u) =>
              UserCard(
                inviteFriend: (){inviteFriend(u);},
                name: u.name,
                photo: u.picture,
              )).toList(),
        ),
      ),
    );
  }
}

