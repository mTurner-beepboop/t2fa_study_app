import 'package:flutter/material.dart';

//TODO - Implement the instructions/instructional videos

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
      body: const Text("Here will be a link to some demonstration videos or something"),
    );
  }
}
