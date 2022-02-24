import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/models/firebase_bloc.dart';
import 'package:todofirebase/views/button_component.dart';
import 'package:todofirebase/views/home.dart';

class Login extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        titleTextStyle: const TextStyle(color: Colors.blue, fontSize: 25),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 30, color: Colors.blue)),
      ),
      backgroundColor: Colors.deepOrange.shade100,
      body: SafeArea(
          child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(
                    labelText: 'Email or phone',
                    hintText: 'Please enter your Email address or phone'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Please enter your password'),
                keyboardType: TextInputType.visiblePassword,
              ),
              ButtonComponent(
                  textShown: 'Login',
                  onTap: () {FocusScope.of(context).unfocus();
                    BlocProvider.of<FireBaseBloc>(context)
                        .loginUser(email.text, password.text)
                        .then((value) {
                      if (value is FirebaseAuthException) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error !',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade600)),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Ok',
                                  ))
                            ],
                            content: Text(value.message!,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.red.shade600)),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }
                    });
                  })
            ],
          ),
        ),
      )),
    );
  }
}
