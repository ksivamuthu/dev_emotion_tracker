import 'package:dev_emotion_tracker/devactivities.dart';
import 'package:flutter/material.dart';

class AddEmotionDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddEmotionDialogState();
  }
}

class AddEmotionDialogState extends State<AddEmotionDialog> {

  List<String> _emotions = List.from(["angry", "bored", "confused", "crying", "embarrassed", "emoticons",
                                      "happy", "ill", "in-love", "kissing", "mad", "nerd", "ninja", "quiet",
                                      "sad", "secret", "smart", "smile", "surprised", "suspicious", "tongue-out", 
                                      "unhappy", "wink"]);

  List<String> _selectedEmotions = new List<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Emotion")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: 
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: _buildEmotionImages(_emotions),
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.chevron_right), 
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext contex) {
                  return DevActivities(emotions: _selectedEmotions);
              }
            ));
          }
      ),
    );
  }

  List<Widget> _buildEmotionImages(List<String> emotions) {
    List<Widget> widgets = List();
    
    widgets.add(FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Icon(Icons.add, size: 50),
          Chip(label: Text("Create"), labelStyle: TextStyle(color: Colors.white), backgroundColor: Colors.green)
        ],
      ),
    ));

    widgets.add(FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Icon(Icons.camera, size: 50),
          Chip(label: Text("Camera"), labelStyle: TextStyle(color: Colors.white), backgroundColor: Colors.green)
        ],
      ),
    ));

    widgets.add(FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Icon(Icons.image, size: 50),
          Chip(label: Text("Gallery"), labelStyle: TextStyle(color: Colors.white), backgroundColor: Colors.green)
        ],
      ),
    ));

    for (var emotion in emotions) {
      widgets.add(
        FlatButton(
          onPressed: () { _onEmotionSelected(emotion); },
          child: Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Image.asset("images/$emotion.png", width: 50, height: 50),
              Chip(label: Text("$emotion"),
               avatar: _selectedEmotions.contains(emotion) ? Icon(Icons.check) : null, 
               labelStyle: TextStyle(color: Colors.white),
               backgroundColor: _selectedEmotions.contains(emotion)? Colors.green: Colors.blueGrey)
            ]
          )
        ) 
      );
    }

    return widgets;
  }

  void _onEmotionSelected(String emotion) {
    setState(() {
      if(_selectedEmotions.contains(emotion)) {
         _selectedEmotions.remove(emotion);
      } else {
        _selectedEmotions.add(emotion);
      }
    });
  }
}