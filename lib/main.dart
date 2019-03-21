import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_emotion_tracker/addemotion.dart';
import 'package:dev_emotion_tracker/models/journalentry.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Emotion Tracker',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Dev Emotion Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser _currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addEmotion() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext contex) {
        return AddEmotionDialog();
      },
      fullscreenDialog: true,
    ));
  }

  @override
  void initState() {
    _auth.signInAnonymously().then((user) {
      setState(() {
        _currentUser = user;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _currentUser != null ? _buildStream() : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmotion,
        tooltip: 'Add Emotion',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildStream() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users/${_currentUser.uid}/journal')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, i) {
        return _buildListItem(context, JournalEntry.fromSnapshot(documents[i]));
      },
    );
  }

  Widget _buildListItem(BuildContext context, JournalEntry journalEntry) {
    final f = new DateFormat('MMM-dd-yyy hh:mm aaa');

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: new BorderSide(
                  width: 1.0,
                  color: Colors.black26,
                ),
              ),
            ),
            child: Image.asset(
              "images/${journalEntry.emotion}.png",
              width: 50,
              height: 50,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  f.format(journalEntry.entryDate),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  journalEntry.emotion.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              journalEntry.activities.join(', '),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
