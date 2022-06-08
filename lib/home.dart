import 'package:flutter/material.dart';
import 'questions.dart';
import 'auth/auth.dart';
import 'local.dart';

///This file contains the code for the main home page of the app. Currently the
///only thing on the home page will be a button to authenticate, however I'm
///sure more will be needed soon

class Home extends StatefulWidget {
  const Home({Key? key, required this.title, required this.firstStart, this.object}) : super(key: key);

  final Objects? object;
  final bool firstStart;
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState(){
    super.initState();
    //Deal with first start information collection
    if (widget.firstStart){
      print("First start");
      WidgetsBinding.instance.addPostFrameCallback((_) {_firstStartDialog();});
    }
  }

  ///Pop-up for first start
  Future<void> _firstStartDialog() async {
    switch (await showDialog<Objects>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text("First Start"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {Navigator.pop(context, Objects.card);},
                  child: const Text("Credit Card"),
                ),
                SimpleDialogOption(
                  onPressed: () {Navigator.pop(context, Objects.pendant);},
                  child: const Text("Pendant"),
                ),
                SimpleDialogOption(
                  onPressed: () {Navigator.pop(context, Objects.cube);},
                  child: const Text("Cube"),
                )
              ]
          );
        }
    )) {
      case Objects.cube:
        writeObject("cube");
        break;
      case Objects.card:
        writeObject("card");
        break;
      case Objects.pendant:
        writeObject("pendant");
        break;
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Thank you for participating in the Tangible 2-Factor Authentication follow-up study, press the button below to perform and authentication!"),
            widget.object == null
            ? const Text("You have yet to select an object")
            : Text(getStringObject(widget.object)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Auth(title: "Authentication Page", object: widget.object)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
              ),
              child: const Text("Continue"),
            ),
            ///TODO - DELETE THIS, DEV TESTING
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Questions()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
              ),
              child: const Text("Recording test"),
            )
          ],
        )
      )
    );
  }
}
