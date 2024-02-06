import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Settings/Settings.dart';
import 'package:todo/TaskList/AddTaskBottomSheet.dart';
import 'package:todo/TaskList/TaskList.dart';
import 'package:todo/Theme_settings/MyTheme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/providers/AuthProvider.dart';

import '../providers/AppConfigProvider.dart';
class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AutheProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(authProvider.currentUser?.name??'',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: provider.isDarkMode()
            ? MyTheme.darkBlackColor
            : MyTheme.whiteColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.list),
                  label: AppLocalizations.of(context)!.task_list),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
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
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs = [const TaskListTab(), const SettingsTab()];

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => const AddTaskBottomSheet());
  }
}
