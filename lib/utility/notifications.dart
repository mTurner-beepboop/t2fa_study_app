import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

///Handler for background messages, notifications will display automatically, if
///any other type of message is received, deal with that here
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

///Handler for foreground messages, in this case notifications do not display
///automatically TODO - Make notifications display
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
