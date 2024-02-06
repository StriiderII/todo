import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/FirebaseUtils/FirebaseErrorCodes.dart';
import 'package:todo/Registration/LoginNavigator.dart';
import 'package:todo/providers/AuthProvider.dart';

class LoginPageViewModel extends ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late LoginNavigator navigator;

  void login() async {
    if (formKey.currentState!.validate() == true) {
      navigator.showMyLoading();
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        navigator.hideMyLoading();
        navigator.showMyMessage('Login Successfully');
/*      var user = await FirebaseUtils.readUserFromFireStore(credential.user?.uid??'');

      if (user == null){
        return;
      }
      var authProvider = Provider.of<AutheProvider>(context,listen: false);
      authProvider.updateUser(user);
      DialogUtils.hideLoading(context);

      DialogUtils.showMessage(context, 'User logged in successfully.',
          posActionName: 'OK', isCancelable: true, posAction: () {
            emailController.clear();
            passwordController.clear();

            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          });*/
      } on FirebaseAuthException catch (e) {
        if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          navigator.hideMyLoading();
          navigator.showMyMessage('No user found or wrong password provided');
        }
      } catch (e) {
        navigator.hideMyLoading();
        navigator.showMyMessage(e.toString());
      }
    }
  }
}
