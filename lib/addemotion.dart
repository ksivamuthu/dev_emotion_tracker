import 'package:dev_emotion_tracker/devactivities.dart';
import 'package:dev_emotion_tracker/models/emotion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmotionDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddEmotionDialogState();
  }
}

class AddEmotionDialogState extends State<AddEmotionDialog> {
  List<String> _emotions;

  Emotion _selectedEmotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Emotion")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: _buildStreamWidget(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chevron_right),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext contex) {
                return DevActivities(emotion: _selectedEmotion);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStreamWidget() {
    return StreamBuilder(
      stream: Firestore.instance.collection("emotions").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        var documents = snapshot.data.documents;
        List<Emotion> emotions = documents.map((f) {
          return Emotion.fromSnapshot(f);
        }).toList();

        return GridView.count(
          crossAxisCount: 3,
          children: _buildEmotionImages(emotions),
        );
      },
    );
  }

  List<Widget> _buildEmotionImages(List<Emotion> emotions) {
    List<Widget> widgets = List();

    widgets.add(FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Icon(Icons.add, size: 50),
          Chip(
              label: Text("Create"),
              labelStyle: TextStyle(color: Colors.white),
              backgroundColor: Colors.green)
        ],
      ),
    ));

    widgets.add(FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Icon(Icons.camera, size: 50),
          Chip(
              label: Text("Camera"),
              labelStyle: TextStyle(color: Colors.white),
              backgroundColor: Colors.green)
        ],
      ),
    ));

    widgets.add(FlatButton(
      onPressed: () {},
      child: Column(
        children: <Widget>[
          Icon(Icons.image, size: 50),
          Chip(
              label: Text("Gallery"),
              labelStyle: TextStyle(color: Colors.white),
              backgroundColor: Colors.green)
        ],
      ),
    ));

    for (var emotion in emotions) {
      widgets.add(
        FlatButton(
          onPressed: () {
            _onEmotionSelected(emotion);
          },
          child: Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Text(
                "${emotion.icon}",
                style: TextStyle(fontSize: 50),
              ),
              Chip(
                label: Text("${emotion.title}"),
                labelStyle: TextStyle(color: Colors.white),
                avatar: _selectedEmotion != null &&
                        _selectedEmotion.id == emotion.id
                    ? Icon(Icons.check)
                    : null,
                backgroundColor: _selectedEmotion != null &&
                        _selectedEmotion.id == emotion.id
                    ? Colors.green
                    : Colors.blueGrey,
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  void _onEmotionSelected(Emotion emotion) {
    setState(() {
      _selectedEmotion = emotion;
    });
  }
}
