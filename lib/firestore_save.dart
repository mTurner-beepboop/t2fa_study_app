import 'package:cloud_firestore/cloud_firestore.dart';

void firestoreSave(bool suc, bool skip, int attemptNum, String object, num timeTaken){
  CollectionReference results =
  FirebaseFirestore.instance.collection('results');
  results
      .add({
    "timestamp": DateTime.now().millisecondsSinceEpoch,
    "success": suc,
    "skip": skip,
    "attempts": attemptNum,
    "object": object,
    "time": timeTaken,
  })
      .then((value) => print("Result added")) //Debug
      .catchError((error) => print("Failed to add: $error")); //Debug
}