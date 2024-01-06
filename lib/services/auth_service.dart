import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_screen/views/home_screen/home_screen.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;
  bool isSignedIn = false;
  Future<void> signUp(BuildContext context, {required String name, required String email, required String password}) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null )  {
        await _registerUser(name: name, email: email, password: password);
        isSignedIn = true;
        navigator.push(MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signIn(BuildContext context, {required String email, required String password}) async {
    final navigator = Navigator.of(context);
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        isSignedIn = true;
        navigator.pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
    } on FirebaseAuthException catch(e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _registerUser({required String name, required String email, required String password}) async {
    await userCollection.doc().set({
      "email" : email,
      "name": name,
      "password": password
    });
  }

  User? getUser(){
    final User? user = firebaseAuth.currentUser;
    if (user != null) {
     return user;
    }
    return null;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    isSignedIn = false;
  }
}