import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:mockingbirdapp/models/song.dart';

class FreestlyeCard extends StatefulWidget {

  @override
  _FreestlyeCardState createState() => _FreestlyeCardState();
}

class _FreestlyeCardState extends State<FreestlyeCard> {
  double _tempoSliderValue = 80;
  double _lengthSliderValue = 30;
  double _singersSliderValue = 2;
  Song freestyleSong = Song(
    backingTrack: "80",
    parts: "2",
    length: 30,
    id: "freestyle",
    difficulty: 3,
    title: "Freestyle"
  );



  @override
  Widget build(BuildContext context) {
    return              Card(
      child: ExpandablePanel(
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 24, 0),
                child: Icon(Icons.create),
              ),
              Text("Create your own!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        expanded: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text("This will create an empty song with no backing track."),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Tempo (bpm)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _tempoSliderValue,
                    min: 80,
                    max: 150,
                    divisions: 14,
                    label: _tempoSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _tempoSliderValue = value;
                        freestyleSong.backingTrack = value.toString();

                      });
                    },
                  )
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Length (sec)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _lengthSliderValue,
                    min: 30,
                    max: 240,
                    divisions: 210,
                    label: _lengthSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        freestyleSong.length = value.toInt();
                        _lengthSliderValue = value;
                      });
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Singers",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _singersSliderValue,
                    min: 2,
                    max: 5,
                    divisions: 3,
                    label: _singersSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        freestyleSong.parts = value.toString();
                        _singersSliderValue = value;
                      });
                    },
                  )
                ],
              ),
              RaisedButton(
                child: Text(
                    "Create song"
                ),
                onPressed: (){Navigator.pop(context, freestyleSong);},
              )
            ],
          ),
        ),
      ),
    );
  }
}
