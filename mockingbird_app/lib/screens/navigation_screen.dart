import 'package:flutter/material.dart';
import 'package:mockingbirdapp/screens/feed/main_feed_screen.dart';
import 'package:mockingbirdapp/screens/projects/create_project/friends_list_screen.dart';
import 'package:mockingbirdapp/screens/projects/current_projects_tab.dart';
import 'package:mockingbirdapp/services/auth.dart';
import 'package:mockingbirdapp/custom_icons/my_flutter_app_icons.dart' as CustomIcon;

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  final AuthService _auth = AuthService();

  List<String> test = [];

  Map<String, Icon> icons =  {
    "Home": Icon(Icons.home),
    "Projects": Icon(Icons.format_paint),
   // "Friends": Icon(Icons.people)
  };

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    MainFeed(),
    CurrentProjectsTab(),
    //FriendsListScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Icon(CustomIcon.MyFlutterApp.twitter_bird),
        ),
        title: Text('Mockingbird'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async{
                await _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              label:Text("Sign Out")
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: icons.keys.map((k)=> BottomNavigationBarItem(
          icon: icons[k],
          title: Text(k),
        )
        ).toList(),
      ),
    );
  }
}
