import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Settings/Settings.dart';
import 'package:todo/TaskList/AddTaskBottomSheet.dart';
import 'package:todo/TaskList/TaskList.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AppConfigProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text('${authProvider.currentUser?.name??''}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: provider.isDarkMode()
            ? MyTheme.darkBlackColor
            : MyTheme.whiteColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: AppLocalizations.of(context)!.task_list),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: AppLocalizations.of(context)!.settings),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(
            color: provider.isDarkMode()
                ? MyTheme.darkBlackColor
                : MyTheme.whiteColor,
            width: 6,
          ),
        ),
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs = [TaskListTab(), SettingsTab()];

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}
