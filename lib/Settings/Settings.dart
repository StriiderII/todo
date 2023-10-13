import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/Registration/LoginPage.dart';
import 'package:todo/Settings/theme_bottom_sheet.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AppConfigProvider.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import 'language_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  showLanguageBottomSheet();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: provider.isDarkMode()
                        ? MyTheme.darkBlackColor
                        : MyTheme.whiteColor,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.appLanguage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                AppLocalizations.of(context)!.theme,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  showThemeBottomSheet();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: provider.isDarkMode()
                        ? MyTheme.darkBlackColor
                        : MyTheme.whiteColor,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.isDarkMode()
                            ? AppLocalizations.of(context)!.dark
                            : AppLocalizations.of(context)!.light,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              ElevatedButton(
                onPressed: () {
                  logout();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.redColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeBottomSheet(),
    );
  }

  void logout() {
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    DialogUtils.showMessage(context, 'You sure you want to logout?',
    posActionName: 'Yes',
      posAction: (){
        authProvider.logout();
        Navigator.pushReplacementNamed(context,
            LoginPage.routeName);
      },
      negActionName: 'Cancel',
    );

  }
}
