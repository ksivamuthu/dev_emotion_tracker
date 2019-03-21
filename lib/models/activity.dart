import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String title;
  final Category category;

  Activity(this.id, this.title, this.category);

  static Activity fromData(String id, Map data, Category category) {
    return Activity(id, data['title'], category);
  }

  static Activity fromSnapShot(
      DocumentSnapshot snapshot, DocumentSnapshot category) {
    return fromData(snapshot.documentID, snapshot.data,
        Category.fromData(category.documentID, category.data));
  }
}

class Category {
  final String id;
  final String title;
  final String icon;

  Category(this.id, this.title, this.icon);

  static Category fromData(String id, Map data) {
    return Category(id, data['title'], data['icon']);
  }

  static Category fromSnapshot(DocumentSnapshot snapshot) {
    return fromData(snapshot.documentID, snapshot.data);
  }
}
