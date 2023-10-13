import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Components/CustomTextFormField.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/FirebaseUtils/FirebaseErrorCodes.dart';
import 'package:todo/Home/HomeScreen.dart';
import 'package:todo/Registration/SignUpPage.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/registration.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  CustomTextFormField(
                    label: 'Email Address',
                    controller: emailController,
                    myValidator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a valid e-mail';
                      }
                      bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(text);
                      if (!emailValid) {
                        return 'Please enter a valid email';
                      }
                    },
                  ),
                  CustomTextFormField(
                    label: 'Password',
                    controller: passwordController,
                    isPassword: true,
                    myValidator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a valid password';
                      }
                      if (text.length < 6) {
                        return 'Password should be at least 6 characters';
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryLight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(SignUpPage.routeName);
                        },
                        child: Text(
                          'Sign up',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = await FirebaseUtils.readUserFromFireStore(credential.user?.uid??'');

        if (user == null){
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context,listen: false);
        authProvider.updateUser(user);
        DialogUtils.hideLoading(context);

        DialogUtils.showMessage(context, 'User logged in successfully.',
            posActionName: 'OK', isCancelable: true, posAction: () {
              emailController.clear();
              passwordController.clear();

              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
      } on FirebaseAuthException catch (e) {
        DialogUtils.hideLoading(context);

        String errorMessage = 'Something went wrong';
        if (e.code == FirebaseErrorCodes.userNotFound ||
            e.code == FirebaseErrorCodes.wrongPassword ||
            e.code == FirebaseErrorCodes.invalidCredintials) {
          errorMessage = 'Wrong email or password';
        }

        DialogUtils.showMessage(context, errorMessage,
            posActionName: 'OK', isCancelable: true, posAction: () {
              emailController.clear();
              passwordController.clear();
            });
      } catch (e) {
        DialogUtils.hideLoading(context); // Step 2: Hide loading dialog

        DialogUtils.showMessage(context, e.toString());
      }
    }
  }

}
