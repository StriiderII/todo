import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Components/CustomTextFormField.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/FirebaseUtils/FirebaseErrorCodes.dart';
import 'package:todo/Home/HomeScreen.dart';
import 'package:todo/Registration/LoginNavigator.dart';
import 'package:todo/Registration/LoginPageViewModel.dart';
import 'package:todo/Registration/SignUpPage.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AuthProvider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login_page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginNavigator{

  late LoginNavigator navigator;

  LoginPageViewModel viewModel  = LoginPageViewModel();

  @override
  void initState(){
    super.initState();
    viewModel.navigator = this;
  }
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/registration.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Form(
              key: viewModel.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                    ),
                    CustomTextFormField(
                      label: 'Email Address',
                      controller: viewModel.emailController,
                      myValidator: (text) {
                        if (text == null || text
                            .trim()
                            .isEmpty) {
                          return 'Please enter a valid e-mail';
                        }
                        bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(text);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      controller: viewModel.passwordController,
                      isPassword: true,
                      myValidator: (text) {
                        if (text == null || text
                            .trim()
                            .isEmpty) {
                          return 'Please enter a valid password';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.login();
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
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.01,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Don't have an account?",
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                SignUpPage.routeName);
                          },
                          child: Text(
                            'Sign up',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
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
      ),
    );
  }



  @override
  void hideMyLoading() {
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading() {
    DialogUtils.showLoading(context, 'Loading');
  }

  @override
  void showMyMessage(String message) {
    DialogUtils.showMessage(context, message);
  }
}