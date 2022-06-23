import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'withdraw.dart';
import 'questions.dart';
import 'tutorial.dart';
import 'auth/auth.dart';
import 'utility/local.dart';

///Home page - This is the first default screen the loads
///Contains: Menu for access to Withdraw, and Help pages, (Questionnaire also
///for debugging purposes) and the link to the authentication page. Also deals
///with some data collection for first start (eg model, participant number)
class Home extends StatefulWidget {
  const Home({Key? key, required this.firstStart}) : super(key: key);

  final bool firstStart;
  final String title = "Home page";

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
              const Text("Please input your participant number \n \n"),
              const SizedBox(height:20),
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

    writeInitFile(objName, participantNum).then((_) {
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Menu"),]
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Questions(skip: false, time: DateTime.now().millisecondsSinceEpoch)),
                );
              },
              leading: const Icon(Icons.question_answer),
              title: const Text("Questionnaire"),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
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
                Navigator.pop(context);
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20,20,20,10),
            child:Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width:2.0)
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Thank you for participating in the Tangible 2-Factor Authentication follow-up study, press the button below to perform an authentication!", textAlign: TextAlign.center),
              )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(width:2.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(objText)
              ),
            )
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ElevatedButton(
              onPressed: () =>
                showDialog<String>(
                  context:context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Authentication"),
                    content: const Text("Do you have your object ready for authentication?"),
                    actions: [
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context, "Yes");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Auth(title: "Authentication Page", object: object)),
                        );
                      },
                          child: const Text("Yes")
                      ),
                      TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.pop(context, "No");
                          }
                      )
                    ]
                  )
                ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5,10,5,10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.lock_open,
                      size: 130,
                    ),
                    Text("Perform Authentication"),
                  ]
                )
              )
            ),
          )
        ],
      )
    );
  }
}
