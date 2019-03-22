import 'package:cloud_firestore/cloud_firestore.dart';

class Emotion {
  final String id;
  final String title;
  final String icon;

  Emotion(this.id, this.title, this.icon);

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "icon": this.icon,
      "title": this.title,
    };
  }

  static Emotion fromSnapshot(DocumentSnapshot snapshot) {
    return fromData(snapshot.documentID, snapshot.data);
  }

  static Emotion fromData(String id, Map data) {
    return Emotion(id, data["title"], data["icon"]);
  }
}
