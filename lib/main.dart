import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/controllers/todo_bloc.dart';
import 'package:todofirebase/models/notification.dart';
import 'package:todofirebase/views/home.dart';
import 'package:todofirebase/views/initial_interface.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBGoQYEuF7i9WWX0LrFHRrPf-Hp3FYtEps',
          appId: '1:754417275926:android:fe48182842ca822d09d137',
          messagingSenderId: '754417275926',
          projectId: 'todofirebase-f3f30'));
  await NotificationController.setupFlutterNotifications();
  NotificationController.showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBGoQYEuF7i9WWX0LrFHRrPf-Hp3FYtEps',
          appId: '1:754417275926:android:fe48182842ca822d09d137',
          messagingSenderId: '754417275926',
          projectId: 'todofirebase-f3f30'));
  if (!kIsWeb) {
    await NotificationController.setupFlutterNotifications();
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.toMap()}');
    NotificationController.showFlutterNotification(message);
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const Root());
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => TodoBloc(),
        lazy: false,
      ),
      BlocProvider(
        create: (context) => FireBaseBloc(),
        lazy: false,
      )
    ], child: const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = SplashScreenView(
      pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
      navigateRoute: BlocProvider.of<FireBaseBloc>(context)
                  .firebaseAuthInstance
                  .currentUser ==
              null
          ? const InitialPage()
          : const Home(),
      duration: 3000,
      text: 'Todo App',
      speed: 250,
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40.0,
      ),
      colors: const [
        Colors.black12,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
    return MaterialApp(
        navigatorKey: Root.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget);
  }
}
