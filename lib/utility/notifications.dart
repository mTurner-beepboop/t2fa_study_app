import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

///Handler for background messages, notifications will display automatically, handle other messages here
///e.g. data
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  //TODO - Add logic for questionnaire request
  print(message.data);
}

///Handler for foreground messages, this will likely not really be needed for the most part,
///however it does generate the token that I think we'll need to sending notifications to
///the device - correction, I think that is for debugging and test purposes
Future<void> firebaseMessagingForegroundHandler() async {
  late FirebaseMessaging messaging;
  messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    print("Token generated");
    print(value);
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message received");
    print(event.notification!.body);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
}
