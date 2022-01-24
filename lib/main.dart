import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:todofirebase/models/firebase_bloc.dart';
import 'package:todofirebase/models/todo_bloc.dart';
import 'package:todofirebase/views/home.dart';
import 'package:todofirebase/views/initial_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBGoQYEuF7i9WWX0LrFHRrPf-Hp3FYtEps',
          appId: '1:754417275926:android:fe48182842ca822d09d137',
          messagingSenderId: '754417275926',
          projectId: 'todofirebase-f3f30'));

  runApp(Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

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
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget widget = SplashScreenView(
      pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
      navigateRoute: BlocProvider.of<FireBaseBloc>(context)
                  .firebaseAuthInstance
                  .currentUser ==
              null
          ? InitialPage()
          : Home(),
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
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget);
  }
}
