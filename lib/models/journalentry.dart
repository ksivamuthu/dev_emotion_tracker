import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_emotion_tracker/models/emotion.dart';

class JournalEntry {
  final String id;
  final Emotion emotion;
  final List<String> activities;
  final DateTime entryDate;

  JournalEntry(this.id, this.emotion, this.activities, this.entryDate);

  static fromData(String id, Map data) {
    return JournalEntry(
      id,
      Emotion.fromData(
        data["emotion"]["id"],
        data["emotion"],
      ),
      List.from(data["activities"]),
      (data["timestamp"] as DateTime),
    );
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    return JournalEntry.fromData(snapshot.documentID, snapshot.data);
  }
}
