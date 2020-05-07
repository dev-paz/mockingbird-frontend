import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  IconData icon;
  String text;

  EmptyStateWidget({ this.icon, this.text });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 100, color: Colors.grey[700]),
          SizedBox(height: 20),
          Text(text, style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700]
          ))
        ],
      )
    );
  }
}
