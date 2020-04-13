import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final num size ;
  Loading({ this.size = 20.0 });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.pink,
          size: size,
        ),
      ),
    );
  }
}