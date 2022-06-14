import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'withdraw.dart';
import 'questions.dart';
import 'tutorial.dart';
import 'auth/auth.dart';
import 'utility/local.dart';

///This file contains the code for the main home page of the app. Currently the
///only thing on the home page will be a button to authenticate, however I'm
///sure more will be needed soon

class Home extends StatefulWidget {
  const Home({Key? key, required this.title, required this.firstStart}) : super(key: key);

  final bool firstStart;
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Objects? object;
  String objText = "You have yet to select an object";

  @override
  void initState(){
    super.initState();
    //Deal with first start information collection
    if (widget.firstStart){
      WidgetsBinding.instance.addPostFrameCallback((_) {_firstStartDialog();});
    }
    //Read object from file
    _updateObj();
  }

  void _updateObj() {
    getObject().then((obj) {
      setState((){
        object = getEnumObject(obj);
        objText = "The object you have been assigned is: " + getStringObject(object);
      });
    });
  }

  ///Pop-up for first start
  Future<void> _firstStartDialog() async {
    String objName;
    int? participantNum;
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
        objName = "cube";
        break;
      case Objects.card:
        objName = "card";
        break;
      case Objects.pendant:
        objName = "pendant";
        break;
      case null:
        objName = "None";
        break;
    }

    var _formKey = GlobalKey<FormState>();
    await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("First Start"),
          content: Stack(
            children: <Widget>[
              const Text("Please input your participant number"),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your participant number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        participantNum = int.parse(value!);
                      }
                    ),
                    TextButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ]
                ),
              ),
            ],
          ),
        );
      },
    );

    writeObject(objName, participantNum).then((_) {
      _updateObj();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding:EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo
              ),
              child: Text("Menu"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Questions()),
                );
              },
              leading: const Icon(Icons.question_answer),
              title: const Text("Questionnaire"),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Tutorial()),
                );
              },
              leading: const Icon(Icons.help_outline),
              title: const Text("How to Use")
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Withdraw()),
                );
              },
              leading: const Icon(Icons.highlight_remove),
              title: const Text("Withdraw participation"),
            )
          ]
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Thank you for participating in the Tangible 2-Factor Authentication follow-up study, press the button below to perform and authentication!", textAlign: TextAlign.center,),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(objText)
          ),
          const SizedBox(
            height: 40,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Auth(title: "Authentication Page", object: object)),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
            ),
            child: const Text("Continue"),
          ),
        ],
      )
    );
  }
}
