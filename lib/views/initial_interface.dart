import 'package:flutter/material.dart';
import 'package:todofirebase/views/button_component.dart';
import 'package:todofirebase/views/login.dart';
import 'package:todofirebase/views/signup.dart';

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrange.shade100,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Icon(
                      Icons.sentiment_very_satisfied_outlined,
                      size: 140,
                      color: Colors.blue,
                    ),
                    Text(
                      '\n \n Welcome to my Todo \n Tasks using firebase app',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonComponent(
                        textShown: 'Signup',
                        onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Signup();
                            }))),
                    ButtonComponent(
                        textShown: 'Login',
                        onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Login();
                            })))
                  ],
                )
              ]),
        ));
  }
}
