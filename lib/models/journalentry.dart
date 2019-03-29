import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_emotion_tracker/models/emotion.dart';

class JournalEntry {
  final Emotion emotion;
  final List<String> activities;
  final DateTime entryDate;

  JournalEntry(this.emotion, this.activities, this.entryDate);

  static fromData(Map data) {
    return JournalEntry(
      Emotion.fromData(
        data["emotion"]["id"],
        data["emotion"],
      ),
      List.from(data["activities"]),
      (data["timestamp"] as DateTime),
    );
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    return JournalEntry.fromData(snapshot.data);
  }
}
