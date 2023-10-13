import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/Registration/LoginPage.dart';
import 'package:todo/Registration/SignUpPage.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import 'package:todo/providers/AppConfigProvider.dart';
import 'firebase_options.dart';
import 'package:todo/Home/HomeScreen.dart';
import 'package:todo/TaskList/TaskDetails.dart';
import 'package:todo/Theme_settings/MyTheme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseFirestore.instance.disableNetwork();
  //FirebaseFirestore.instance.settings =
  //const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfigProvider>(
          create: (context) => AppConfigProvider(),
        ),
        ChangeNotifierProvider<ListProvider>(
          create: (context) => ListProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider()
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SignUpPage.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        TaskDetailsScreen.routeName: (context) => TaskDetailsScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),

      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: MyTheme.LightTheme,
      locale: Locale(provider.appLanguage),
      themeMode: provider.appTheme,
      darkTheme: MyTheme.darkTheme,
    );
  }
}
