import 'package:dev_emotion_tracker/models/activity.dart';
import 'package:flutter/material.dart';

class DevActivities extends StatefulWidget {

  final List<String> emotions;

  DevActivities({Key key, @required this.emotions}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DevActivitiesState(this.emotions);
  }
}

class DevActivitiesState extends State<DevActivities> {

  List<String> selectedEmotions;
  List<Activity> selectedActivities = List();

  DevActivitiesState(this.selectedEmotions):super();

  List<Activity> _developerActivities = List.from([
    Activity("Coding", Category.Development),
    Activity("Meeting", Category.Development),
    Activity("Defects", Category.Development),
    Activity("Presentation", Category.Development),
    Activity("1 on 1", Category.Development),
    Activity("PR reviews", Category.Development),
    Activity("Meetup", Category.Development),
    Activity("Play Time", Category.Development),
    Activity("Scrum", Category.Development),
    Activity("Coffee", Category.Development),
    Activity("Running", Category.Health),
    Activity("Exercise", Category.Health),
    Activity("Travel", Category.Health),
    Activity("Vacation", Category.Health),
  ]);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text("Developer Activities")),
       body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Wrap(
            runSpacing: 20.0,
            spacing: 10.0,
            children: _buildActivitiesList(_developerActivities),
          )
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: () {},
         child: Icon(Icons.chevron_right),
       ),
     );
  }

  List<Widget> _buildActivitiesList(List<Activity> devActivities) {
    List<Widget> chips = List();
    for (var devActivity in devActivities) {
      chips.add(ChoiceChip(
          label: Text(devActivity.title),
          labelPadding: EdgeInsets.only(left: 10, right: 10),
          labelStyle: TextStyle(fontSize: 22, color: Colors.black), 
          selected: selectedActivities.contains(devActivity),
          onSelected: (bool value) {
            setState(() {
              if(value) {
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
}