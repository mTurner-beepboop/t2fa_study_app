import 'package:flutter/material.dart';

import 'home.dart';
import 'utility/firestore_save.dart';
import 'utility/local.dart';

//TODO - Save answers to firestore

///Questions page - This is where the user is directed to upon completion of an
///authentication attempt. Currently contains question templates for both free text input
///and multiple choice questions
class Questions extends StatefulWidget {
  const Questions({Key? key, required this.skip, required this.time}) : super(key: key);

  final num time; //Stores the time the authentication took place (so it can be linked to the authentication attempt)
  final bool skip; //Stores whether the authentication was skipped

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionnaire"),
      ),
      body: Center(
        child: QuestionsForm(time: widget.time, skip: widget.skip),
      ),
    );
  }
}

class QuestionsForm extends StatefulWidget {
  const QuestionsForm({Key? key, required this.time, required this.skip}) : super(key: key);

  final num time;
  final bool skip;

  @override
  State<QuestionsForm> createState() => _QuestionsFormState();
}

class _QuestionsFormState extends State<QuestionsForm> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> answers = ["", null];
  var _iToggle1 = [false, false, false, false, false];
  String? error;

  void _handleSubmit(ans){
    getParticipantNum().then((value) => firestoreQuestionsSave(ans, widget.time, widget.skip, value));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///Text Input Template
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text("Free Text Question", textAlign: TextAlign.center),
                  TextFormField(
                      decoration: const InputDecoration(errorStyle: TextStyle(color: Colors.red)),
                      onSaved: (value) => answers[0] = value!,
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return "Please enter some text";
                        }
                        return null;
                      }
                  ),
                ],
              ),
            ),
            ///MCQ Template
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text("Multiple Choice Question", textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: _iToggle1[0] ? const Icon(Icons.looks_one) : const Icon(Icons.looks_one_outlined),
                          onPressed: () {
                            setState((){
                              _iToggle1 = [true, false, false, false, false];
                              answers[1] = 0;
                            });
                          }
                      ),
                      IconButton(
                          icon: _iToggle1[1] ? const Icon(Icons.looks_two) : const Icon(Icons.looks_two_outlined),
                          onPressed: () {
                            setState((){
                              _iToggle1 = [false, true, false, false, false];
                              answers[1] = 1;
                            });
                          }
                      ),
                      IconButton(
                          icon: _iToggle1[2] ? const Icon(Icons.looks_3) : const Icon(Icons.looks_3_outlined),
                          onPressed: () {
                            setState((){
                              _iToggle1 = [false, false, true, false, false];
                              answers[1] = 2;
                            });
                          }
                      ),
                      IconButton(
                          icon: _iToggle1[3] ? const Icon(Icons.looks_4) : const Icon(Icons.looks_4_outlined),
                          onPressed: () {
                            setState((){
                              _iToggle1 = [false, false, false, true, false];
                              answers[1] = 3;
                            });
                          }
                      ),
                      IconButton(
                          icon: _iToggle1[4] ? const Icon(Icons.looks_5) : const Icon(Icons.looks_5_outlined),
                          onPressed: () {
                            setState((){
                              _iToggle1 = [false, false, false, false, true];
                              answers[1] = 4;
                            });
                          }
                      ),
                    ],
                  ),
                  error != null ? Text(error!, style: const TextStyle(color: Colors.red, fontSize: 12)) : const Text(""),
                ],
              ),
            ),
            ///Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && answers[1] != null){
                  _formKey.currentState!.save();
                  _handleSubmit(answers);
                  setState((){
                    error = null;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Home(firstStart: false)
                    ),
                  );
                }
                else {
                  setState((){
                    error = "Please make a selection";
                  });
                }
              },
              child: const Text("Submit"),
            )
          ],
        )
      )
    );
  }
}
