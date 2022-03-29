import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/views/components/button_component.dart';
import 'package:todofirebase/views/components/custom_textfield.dart';
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
                          CustomTextField(
                            controller: email,
                            label: 'Email or phone',
                            hint: 'Please enter your Email address or phone',
                            type: TextInputType.emailAddress,
                          ),
                          CustomTextField(
                            obscure: true,
                            controller: password,
                            label: 'Password',
                            hint: 'Please enter your password',
                            type: TextInputType.visiblePassword,
                          ),
                          ButtonComponent(
                              textShown: 'Login',
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                BlocProvider.of<FireBaseBloc>(context)
                                    .loginUser(
                                        email.text, password.text, context);
                              })
                        ])))));
  }
}
