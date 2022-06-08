import 'package:flutter/material.dart';
import '../firestore_save.dart';
import 'card_auth.dart';
import 'pendant_auth.dart';
import 'cube_auth.dart';
import 'pointer_pair.dart';
import 'package:t2fa_usability_app/local.dart';

/// Below is a prototype for the collection of authentication methods, including how touch points are collected and a basic UI
///
/// Still to do: Add in functionality for specific objects, basically all of the functions that aren't just touch point collection

class Auth extends StatefulWidget {
  const Auth({Key? key, required this.title, required this.object})
      : super(key: key);

  final Objects?
      object; //This should never be null, but required in this implementation
  final String title;

  @override
  State<Auth> createState() => _AuthState();
}

///Contains almost all of the authentication logic
class _AuthState extends State<Auth> {
  List<PointerPair> points =
      []; //Represents a list of currently active touch points
  List<PointerPair> allPoints =
      []; //Represents a list of the pressed points for authentication

  var textContent = "No attempt yet"; //Mostly for debug currently, refers to the text in the debug box below the touch area
  var _attemptNum = 1; //1 indexed attempt number for readability in data
  var initialTime = 0; //Time currently starts from the moment the first touch happens, and ends when the authentication button is clicked successfully

  final num _maxAttempts = 3; //Easy way to change max number of attempts allowed

  ///Add a new pointer pair to the list of active pointers
  void _addPoint(PointerPair p) {
    points.add(p);
    allPoints.add(p);
  }

  ///Removes the specified point from the list - by pointer ID
  void _removePoints(int pointerId) {
    points.removeWhere((item) => item.id == pointerId);
  }

  ///Here we can add the authentication logic, this whole class will need to be different for each of the objects, but regardless here is where the final check should happen
  ///For now we just have a return of the location of all the points in a snack bar
  ///This is probably where we can handle the file writing
  void _authenticateAttempt() {
    //In theory, check authentication success
    //Retrieve the correct function for the current object
    bool Function(List<PointerPair>) authFunc;
    switch (widget.object) {
      case Objects.card:
        authFunc = cardAuth;
        break;
      case Objects.pendant:
        authFunc = pendantAuth;
        break;
      case Objects.cube:
        authFunc = cubeAuth;
        break;
      default: //In this case no object was chosen hence the authentication cannot be carried out - this shouldn't happen ever
        return;
    }

    //If final state, log current time and calculate time taken to authenticate
    num _timeTaken = 0;

    //Check authentication success
    bool suc = authFunc(allPoints);
    if (suc) {
      _timeTaken = _endTimer();
      firestoreSave(true, false, _attemptNum, getStringObject(widget.object), _timeTaken);
      //TODO - Redirect away from this page
    }

    //Check authentication attempt number (if 3 then end)
    if (_attemptNum == _maxAttempts) {
      _timeTaken = _endTimer();
      firestoreSave(false, false, _attemptNum, getStringObject(widget.object), _timeTaken);
      //TODO - Redirect away from this page
    }

    //Alter required variables after attempt
    //First iterate attemptNum if last attempt failed and not final allowed attempt
    if (!suc && _attemptNum != _maxAttempts) {
      _attemptNum += 1;
    }

    //TODO - Remove this debugging information in production
    String txt = "Last attempt included:";
    for (PointerPair point in allPoints) {
      txt += " id: ${point.id} (${point.x}, ${point.y})";
    }
    _changeText(txt + ". Time taken: $_timeTaken");

    //Remove all points from the authentication
    while (allPoints.isNotEmpty) {
      allPoints.removeAt(0);
    }
  }

  ///Called when user wants to skip this authentication for any reason
  void _skipAuth() {
    var _timeTaken = _endTimer();
    firestoreSave(false, true, _attemptNum, getStringObject(widget.object), _timeTaken);
    //TODO - Redirect away from this page
  }

  ///Controls the text in the debug text box
  void _changeText(msg) {
    setState(() {
      textContent = msg;
    });
  }

  ///Log current time for tracking authentication attempt time
  void _startTimer() {
    setState(() {
      initialTime = DateTime.now().millisecondsSinceEpoch;
    });
  }

  ///Calculate final time and set initial timer back to zero
  num _endTimer() {
    num timeElapsed = DateTime.now().millisecondsSinceEpoch - initialTime;
    setState(() {
      _attemptNum = 1;
    });
    return timeElapsed;
  }

  ///Override initialisation to ensure time taken to authenticate is collected from moment the page opens
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        ///This is where all the actual UI stuff goes
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //This is where the testing for the button is
            Listener(
              onPointerDown: (event) {
                ///This should be consistent for each object

                //Event contains all the PointerEvent details
                var x = event.position.dx;
                var y = event.position.dy;
                var id = event.pointer; //Unique identifier for the point.
                _addPoint(PointerPair(x, y, id));
              },
              onPointerUp: (event) {
                ///This will in particular be unique for each object
                ///So probably needs an if or case statement to check that

                //Get the event pointer id
                var pointerId = event.pointer;

                //Remove point from the list
                _removePoints(pointerId);

                //Build a string to display debugging info
                String text = "Active Points at: ";
                for (PointerPair point in points) {
                  text += "(${point.x}, ${point.y}) with id: ${point.id} ";
                }

                text +=
                    ". Deactivated Point at: (${event.position.dx} ,${event.position.dy}), with ID: $pointerId";

                //Create a snack bar to display the information in
                var snackBar = SnackBar(content: Text(text));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
                ///This is the actual area which collects the touch point information
                width: 300,
                height:
                    300, //So if we want a little outline for where to put things, this is where that'll be changed, not entirely sure of how each number relates to size though
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 2.0, color: Colors.black),
                ),
              ),
            ),
            Text(textContent),

            ///Debug for authentication attempt information
            TextButton(
              ///The authentication attempt button
              onPressed: () {
                _authenticateAttempt();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black12)),
              child: const Text("Press to authenticate"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black12)),
              child: const Text("Return home"),
            ),
            TextButton(
                onPressed: () {
                  _skipAuth();
                },
                child: const Text("Press here to skip auth")),
          ],
        ),
      ),
    );
  }
}
