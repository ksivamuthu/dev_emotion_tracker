import 'package:dev_emotion_tracker/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DevActivities extends StatefulWidget {
  final String emotion;

  DevActivities({Key key, @required this.emotion}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DevActivitiesState(this.emotion);
  }
}

class DevActivitiesState extends State<DevActivities> {
  String selectedEmotion;
  List<Activity> selectedActivities = List();
  List<Activity> _developerActivities;
  List<Category> _categories;
  DevActivitiesState(this.selectedEmotion) : super();

  @override
  void initState() {
    getCategories().then((categories) {
      setState(() {
        _categories = categories;
      });
      getDeveloperActivities().then((activities) {
        setState(() {
          _developerActivities = activities;
        });
      });
    });

    super.initState();
  }

  Future<List<Category>> getCategories() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("categories").getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;
    List<Category> categories = docs.map((cat) {
      return Category.fromSnapshot(cat);
    }).toList();

    return categories;
  }

  Future<List<Activity>> getDeveloperActivities() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("activities").getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;
    List<Activity> activities = List();
    for (var doc in docs) {
      DocumentReference catRef = doc["category"];
      Category category = _categories.firstWhere((cat) {
        return cat.id == catRef.documentID;
      });
      activities.add(Activity.fromData(doc.documentID, doc.data, category));
    }

    return activities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Developer Activities")),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: _developerActivities != null
            ? _buildCategoriesList(context, _categories)
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveEmotion();
        },
        child: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, i) {
        Category category = categories[i];
        return ListTile(
          title: Padding(
            padding: EdgeInsets.only(
              left: 5,
              top: 10,
              bottom: 10,
              right: 5,
            ),
            child: Row(children: [
              Text(
                category.icon,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(width: 20),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.purple,
                ),
              ),
            ]),
          ),
          subtitle: _buildWrap(category),
        );
      },
    );
  }

  Widget _buildWrap(Category category) {
    List<Activity> categoryActivities = _developerActivities.where((x) {
      return x.category.id == category.id;
    }).toList();

    return Wrap(
      runSpacing: 20.0,
      spacing: 10.0,
      children: _buildActivitiesList(categoryActivities),
    );
  }

  List<Widget> _buildActivitiesList(List<Activity> devActivities) {
    List<Widget> chips = List();
    for (var devActivity in devActivities) {
      chips.add(ChoiceChip(
        label: Text(devActivity.title),
        labelPadding: EdgeInsets.only(left: 10, right: 10),
        labelStyle: TextStyle(fontSize: 20, color: Colors.black),
        selectedColor: Colors.lightGreen,
        selected: selectedActivities.contains(devActivity),
        onSelected: (bool value) {
          setState(() {
            if (value) {
              selectedActivities.add(devActivity);
            } else {
              selectedActivities.remove(devActivity);
            }
          });
        },
      ));
    }

    return chips;
  }

  void saveEmotion() {
    var activities = this.selectedActivities;

    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users/' + user.uid + '/journal')
          .document()
          .setData({
        'emotion': this.selectedEmotion,
        'activities': FieldValue.arrayUnion(activities.map((f) {
          return f.title;
        }).toList()),
        'timestamp': DateTime.now()
      });
    });

    Navigator.of(context).popUntil((x) {
      return x.isFirst;
    });
  }
}
