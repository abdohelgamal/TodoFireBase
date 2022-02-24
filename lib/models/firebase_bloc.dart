import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseBloc extends Cubit {
  FireBaseBloc() : super(0) {
    firebaseAuthInstance = FirebaseAuth.instance;
    firebaseFirestoreInstance = FirebaseFirestore.instance;
  }

  late FirebaseAuth firebaseAuthInstance;
  late FirebaseFirestore firebaseFirestoreInstance;

  Future getTasks() async {
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

  Future<dynamic> registerUser(
    String email,
    String name,
    String phone,
    String password,
  ) async {
    try {
      return await firebaseAuthInstance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {if (firebaseAuthInstance.currentUser != null){
        firebaseFirestoreInstance
            .collection('users')
            .doc(firebaseAuthInstance.currentUser!.uid)
            .set({'email': email, 'name': name, 'phone': phone, 'tasks': []});}
      });
    } on FirebaseAuthException catch (error) {
      return error;
    }
  }

  Future<dynamic> loginUser(
    String emailOrPhone,
    String password,
  ) async {
    try {
      return await firebaseAuthInstance.signInWithEmailAndPassword(
          email: emailOrPhone, password: password);
    } on FirebaseAuthException catch (error) {
      return error;
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
