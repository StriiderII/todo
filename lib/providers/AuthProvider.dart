import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/Model/User.dart' ;
class AutheProvider extends ChangeNotifier{
  MyUser? currentUser;
  MyUser? firebaseAuthUser;

  void updateUser(MyUser newUser){
    currentUser = newUser;
    notifyListeners();
  }




  void logout() {
    currentUser = null;
    FirebaseAuth.instance.signOut();
  }

  bool isUserLoggedInBefore() {
   return FirebaseAuth.instance.currentUser !=null;
  }



}