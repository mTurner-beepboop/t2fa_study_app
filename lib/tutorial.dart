import 'package:flutter/material.dart';

//TODO - Implement the instructions/instructional videos

///Tutorial page - This is where the user can find instructions on how to work
///the model they have been assigned
class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Here will be a link to some demonstration videos or something similar"),
        ]
      )
    );
  }
}
