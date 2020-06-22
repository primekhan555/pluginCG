import 'package:cloud_firestore/cloud_firestore.dart';

test(String testName, String timeStamp, String uid) {
  Firestore.instance
      .collection("test_reminders")
      .document()
      .setData({"testName": "$testName", "timeStamp": "$timeStamp", "uid": "$uid"});
}
