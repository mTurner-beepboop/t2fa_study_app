import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

//TODO - Implement a way to withdraw from the study (probably just send in a request to firebase with id of participant and such)

///Currently, this page offers users a way to remove themselves from the study by unsubscribing from the notification topic -
///ie they won't receive reminders anymore. This may need to be updated to save a document to firestore so that
///we can keep track of which participants have withdrawn.

Future<void> unsubscribe() async {
  await FirebaseMessaging.instance.unsubscribeFromTopic("active_participant");
}

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  var isActive = true;
  var text = "Press the button below to withdraw from the study. Further instructions will be provided upon withdrawal.";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
      ),
      body: Column(children: [
        Text(text),
        const SizedBox(
          height: 30,
        ),
        isActive
        ? TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Withdraw"),
              content: const Text("Be aware, this cannot be undone. Are you sure you want to withdraw from the study?"),
              actions: [
                TextButton(
                  onPressed: () {
                    unsubscribe().then((result) {
                      setState(() {
                        isActive = false;
                        text = "You have withdrawn from the study. Please contact ... to confirm this and discuss any compensation.";
                      });
                      Navigator.pop(context, 'Yes');
                    });
                  },
                  child: const Text("Yes"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'No');
                  },
                  child: const Text("No")),
              ])),
          child: const Text("Withdraw"),
        )
        : const Text("You have withdrawn and will no longer receive notifications"),
      ])
    );
  }
}
