import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String emotion;
  final List<String> activities;
  final DateTime entryDate;

  JournalEntry(this.emotion, this.activities, this.entryDate);

  static fromData(Map data) {
    return JournalEntry(
      data["emotion"],
      List.from(data["activities"]),
      (data["timestamp"] as Timestamp).toDate(),
    );
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    return JournalEntry.fromData(snapshot.data);
  }
}
