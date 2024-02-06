import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/Registration/SignUpNavigator.dart';

import '../FirebaseUtils/FireBaseUtils.dart';
import '../FirebaseUtils/FirebaseErrorCodes.dart';
import '../providers/AuthProvider.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late RegisterNavigator navigator;
  void register(String email, String password) async {
    if (formKey.currentState?.validate() == true) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == FirebaseErrorCodes.emailInUse) {
          navigator.hideMyLoading();
          navigator.showMyMessage('Email Already in Use.');
        } else if (e.code == FirebaseErrorCodes.weakPassword) {
          navigator.hideMyLoading();
          navigator.showMyMessage('Weak Password.');
        }
      } catch (e) {
        navigator.hideMyLoading();
        navigator.showMyMessage(e.toString());
      }
    }
    navigator.showMyLoading();
  }
}
