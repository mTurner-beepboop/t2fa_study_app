import 'package:flutter/material.dart';
import 'utility/local.dart';

//TODO - Implement the instructions/instructional videos

///Tutorial page - This is where the user can find instructions on how to work
///the model they have been assigned
class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  String? obj;

  @override
  void initState() {
    super.initState();
    getObject().then((value) {
      setState((){
        obj = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getEnumObject(obj!) == Objects.cube ?
            const Text("Here will be instructions for the cube") : const SizedBox(height:0),
          getEnumObject(obj!) == Objects.pendant ?
            const Text("Here will be instructions for the pendant") : const SizedBox(height:0),
          getEnumObject(obj!) == Objects.card ?
            const Text("Here will be instructions for the card") : const SizedBox(height:0),
        ]
      )
    );
  }
}
