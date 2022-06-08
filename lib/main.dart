import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:t2fa_usability_app/local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'notifications.dart';
import 'home.dart';

//TODO add the firebase store or whichever one we use

///Set up the app
void main() async {
  //First initialise connection to firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Deal with background notifications here
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //Set a new notification channel for Android to allow heads-up notifications
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //Set foreground notification settings for iOS
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //Check if this is the first start by looking for the file on disk]
  String storedObj = await getObject();
  var first = false;
  Objects? obj;
  if (storedObj == "None"){
    first = true;
  } else {
    obj = getEnumObject(storedObj);
  }

  //Display the home page here
  runApp(MainApp(firstStart: first, object: obj));
}

///Create the main app state
class MainApp extends StatefulWidget {
  const MainApp({Key? key, required this.firstStart, this.object}) : super(key: key);

  final Objects? object;
  final bool firstStart;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState(){
    super.initState();
    //Set up how we deal with foreground messages
    firebaseMessagingForegroundHandler();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T2FA Follow-Up App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Home page', firstStart: widget.firstStart, object:widget.object),
    );
  }
}
