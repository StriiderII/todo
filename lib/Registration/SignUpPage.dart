import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Components/CustomTextFormField.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/FirebaseUtils/FirebaseErrorCodes.dart';
import 'package:todo/Model/User.dart';
import 'package:todo/Registration/LoginPage.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AuthProvider.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = 'sign_up_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/registration.png',
            width: double.infinity,
            fit: BoxFit.cover,
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
                    label: 'User Name',
                    controller: nameController,
                    myValidator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a valid username';
                      }
                    },
                  ),
                  CustomTextFormField(
                    label: 'Email Address',
                    controller: emailController,
                    myValidator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a valid e-mail';
                      }
                      bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
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
                  CustomTextFormField(
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    isPassword: true,
                    myValidator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter a confirmation password';
                      }
                      if (text != passwordController.text) {
                        return 'Password does not match!';
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: (){
                      register();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.primaryLight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Register',
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
                        "Already have an account?",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
                        },
                        child: Text(
                          'Login',
                          style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
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

  void register() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoading(context, 'Loading...');
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final myUser = MyUser(
        name: nameController.text,
        email: emailController.text,
        id: credential.user?.uid ?? "",
      );
      var authProvider = Provider.of<AuthProvider>(context,listen: false);
      authProvider.updateUser(myUser);
      await FirebaseUtils.addUserToFireStore(myUser);
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(
        context,
        'User registered successfully.',
        posActionName: 'OK',
        posAction: () {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrorCodes.emailInUse) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'The email you provided is already in use',
          posActionName: 'OK',
          posAction: () {

            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          },
        );
      } else if (e.code == FirebaseErrorCodes.weakPassword) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Weak password provided for that email');
      }
    } catch (e) {
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(context, e.toString());

    }
  }
}
