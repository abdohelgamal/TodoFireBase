import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/views/home.dart';

class FireBaseBloc extends Cubit {
  FireBaseBloc() : super(0) {
    firebaseAuthInstance = FirebaseAuth.instance;
    firebaseFirestoreInstance = FirebaseFirestore.instance;
  }

  late FirebaseAuth firebaseAuthInstance;
  late FirebaseFirestore firebaseFirestoreInstance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getTasks() async {
    return await firebaseFirestoreInstance
        .collection('users')
        .doc(firebaseAuthInstance.currentUser!.uid)
        .get();
  }

  updateTasks(List<Map> tasks) async {
    firebaseFirestoreInstance
        .collection('users')
        .doc(firebaseAuthInstance.currentUser!.uid)
        .update({'tasks': tasks});
  }

  Future<dynamic> registerUser(String email, String name, String phone,
      String password, BuildContext ctx) async {
    try {
      return await firebaseAuthInstance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        if (firebaseAuthInstance.currentUser != null) {
          firebaseFirestoreInstance
              .collection('users')
              .doc(firebaseAuthInstance.currentUser!.uid)
              .set({
            'email': email,
            'name': name,
            'phone': phone,
            'tasks': []
          }).whenComplete(() {
            Navigator.pop(ctx);
            Navigator.pushReplacement(
                ctx, MaterialPageRoute(builder: (context) => const Home()));
          });
        }
      });
    } on FirebaseAuthException catch (error) {
      showDialog(
        context: ctx,
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
          content: Text(error.message!,
              style: TextStyle(fontSize: 18, color: Colors.red.shade600)),
        ),
      );
    }
  }

  Future<dynamic> loginUser(
      String emailOrPhone, String password, BuildContext ctx) async {
    try {
      return await firebaseAuthInstance
          .signInWithEmailAndPassword(email: emailOrPhone, password: password)
          .whenComplete(() {
        if (firebaseAuthInstance.currentUser != null) {
          Navigator.pop(ctx);
          Navigator.pushReplacement(
              ctx, MaterialPageRoute(builder: (context) => const Home()));
        }
      });
    } on FirebaseAuthException catch (error) {
      showDialog(
          context: ctx,
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
              content: Text(error.message!,
                  style: TextStyle(fontSize: 18, color: Colors.red.shade600))));
    }
  }

  Future<dynamic> logout() async {
    try {
      await firebaseAuthInstance.signOut();
    } on FirebaseAuthException catch (error) {
      return error;
    }
  }
}
