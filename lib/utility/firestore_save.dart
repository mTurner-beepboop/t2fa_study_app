import 'package:cloud_firestore/cloud_firestore.dart';

///Utility function to save authentication data in correct form to firestore in
///'results' collection
void firestoreAuthSave(
    bool suc, bool skip, int attemptNum, String object, num timeTaken, num id) {
  CollectionReference results =
      FirebaseFirestore.instance.collection('results');
  results
      .add({
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "id": id,
        "success": suc,
        "skip": skip,
        "attempts": attemptNum,
        "object": object,
        "time": timeTaken,
      })
      .then((value) => print("Result added")) //Debug
      .catchError((error) => print("Failed to add: $error")); //Debug
}

///Utility function to save withdrawn status in correct form to firestore in
///'withdrawn' collection
void firestoreWithdrawSave(num id) {
  CollectionReference withdraw =
      FirebaseFirestore.instance.collection('withdraw');
  withdraw
      .add({
        "id": id,
      })
      .then((value) => print("Status added")) //Debug
      .catchError((error) => print("Failed to add: $error")); //Debug
}
