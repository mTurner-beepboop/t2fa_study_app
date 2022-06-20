import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:t2fa_usability_app/utility/local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'utility/firebase_options.dart';
import 'utility/notifications.dart';
import 'home.dart';

///Main drive for App startup, sets up notification settings, firebase connection
///deals with some first start logic and passes the first start variable to Home
///which deals with the rest. Additionally, this is where the app theme is defined
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

  //Check if this is the first start by looking for the file on disk
  String storedObj = await getObject();
  var first = false;
  if (storedObj == "None"){
    first = true;
    FirebaseMessaging.instance.subscribeToTopic("active_participant");
  }

  //Display the home page here
  runApp(MainApp(firstStart: first));
}

///Create the main app state
class MainApp extends StatefulWidget {
  const MainApp({Key? key, required this.firstStart}) : super(key: key);

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
        primarySwatch: Colors.indigo,
      ),
      home: Home(firstStart: widget.firstStart),
    );
  }
}
