import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/views/components/button_component.dart';
import 'package:todofirebase/views/components/custom_textfield.dart';

class Signup extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: email,
                label: 'Email',
                hint: 'Please enter your Email address',
                type: TextInputType.emailAddress,
              ),
              CustomTextField(
                controller: name,
                label: 'Full Name',
                hint: 'Please enter your full name',
              ),
              CustomTextField(
                controller: phone,
                label: 'Phone',
                hint: 'Please enter your phone',
                type: TextInputType.phone,
              ),
              CustomTextField(
                obscure: true,
                controller: password,
                label: 'Password',
                hint: 'Please enter your password',
                type: TextInputType.visiblePassword,
              ),
              ButtonComponent(
                  textShown: 'Signup',
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<FireBaseBloc>(context).registerUser(
                        email.text,
                        name.text,
                        phone.text,
                        password.text,
                        context);
                  })
            ],
          ),
        ),
      )),
    );
  }
}
