import 'package:dev_emotion_tracker/devactivities.dart';
import 'package:dev_emotion_tracker/models/emotion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:device_info/device_info.dart';

class AddEmotionDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddEmotionDialogState();
  }
}

class AddEmotionDialogState extends State<AddEmotionDialog> {
  List<Emotion> _emotions;

  Emotion _selectedEmotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Emotion"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_enhance),
            onPressed: () async {
              var isPhysicalDevice =
                  (await DeviceInfoPlugin().iosInfo).isPhysicalDevice;
              final image = await ImagePicker.pickImage(
                  source: isPhysicalDevice
                      ? ImageSource.camera
                      : ImageSource.gallery,
                  maxWidth: 800,
                  maxHeight: 600);
              if (image == null) return;

              final FirebaseVisionImage visionImage =
                  FirebaseVisionImage.fromFile(image);
              final FaceDetector faceDetector =
                  FirebaseVision.instance.faceDetector(
                FaceDetectorOptions(enableClassification: true),
              );
              var faces = await faceDetector.detectInImage(visionImage);
              if (faces != null && faces.length > 0) {
                var probability = faces[0].smilingProbability;
                var sentiment = '';
                if (probability >= 0.7) {
                  sentiment = 'happy';
                } else if (probability < 0.7 && probability >= 0.4) {
                  sentiment = 'neutral';
                } else {
                  sentiment = 'sad';
                }

                setState(() {
                  this._selectedEmotion = _emotions.firstWhere((x) {
                    return x.id == sentiment;
                  });
                });
              }
            },
          )
        ],
      ),
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

        this._emotions = emotions;

        return GridView.count(
          crossAxisCount: 3,
          children: _buildEmotionImages(emotions),
        );
      },
    );
  }

  List<Widget> _buildEmotionImages(List<Emotion> emotions) {
    List<Widget> widgets = List();

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
