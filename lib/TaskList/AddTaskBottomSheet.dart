import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/Model/Task.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import '../providers/ListProvider.dart';
import '../providers/AppConfigProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider;
  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      color:
          provider.isDarkMode() ? MyTheme.darkBlackColor : MyTheme.whiteColor,
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.add_new_task,
            style: provider.isDarkMode()
                ? Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: MyTheme.whiteColor)
                : Theme.of(context).textTheme.titleMedium,
          ),
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.enter_task_title,
                        hintStyle: TextStyle(
                          color: provider.isDarkMode()
                              ? MyTheme.greyColor
                              : MyTheme.greyColor,
                        ),
                      ),
                      style: TextStyle(
                        color: provider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .enter_task_description,
                        hintStyle: TextStyle(
                          color: provider.isDarkMode()
                              ? MyTheme.greyColor
                              : MyTheme.greyColor,
                        ),
                      ),
                      style: TextStyle(
                        color: provider.isDarkMode()
                            ? MyTheme.whiteColor
                            : MyTheme.blackColor,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.select_date,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: provider.isDarkMode()
                                ? MyTheme.greyColor
                                : MyTheme.blackColor,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showCalendar();
                      },
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/'
                        '${selectedDate.year}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: provider.isDarkMode()
                                  ? MyTheme.greyColor
                                  : MyTheme.blackColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: Theme.of(context).textTheme.titleLarge,
                      ))
                ],
              )),
        ],
      ),
    );
  }

  Future<void> showCalendar() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
  }

  Future<void> addTask() async {
    if (formKey.currentState?.validate() == true) {
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, 'Loading...');


      await FirebaseUtils.addTaskToFirebase(task, authProvider.currentUser!.id!);


      await listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);

      DialogUtils.hideLoading(context);
      Navigator.pop(context);
    }
  }
}
