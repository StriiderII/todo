import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AppConfigProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDetailsScreen extends StatefulWidget {
  static const String routeName = 'task_details_screen';

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();

  // Create TextEditingController for task title and description
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 100),
          padding: EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: provider.isDarkMode()
                    ? MyTheme.darkBlackColor
                    : MyTheme.whiteColor,
                borderRadius: BorderRadius.circular(15),

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(AppLocalizations.of(context)!.edit_task,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: provider.isDarkMode()
                          ?MyTheme.whiteColor
                          :MyTheme.blackColor
                    ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _titleController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.this_is_title,
                        hintStyle: TextStyle(
                          color: provider.isDarkMode() ? MyTheme.greyColor : MyTheme.blackColor,
                        ),
                      ),
                      style: TextStyle(
                          color: provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.blackColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _descriptionController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter task details';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.task_details,
                        hintStyle: TextStyle(
                          color: provider.isDarkMode() ? MyTheme.greyColor : MyTheme.blackColor,
                        ),
                      ),
                      style: TextStyle(
                        color: provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.blackColor,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select date',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: provider.isDarkMode() ? MyTheme.greyColor : MyTheme.blackColor,
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
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: provider.isDarkMode() ? MyTheme.greyColor : MyTheme.blackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 100,),
                  Container(
                    margin: EdgeInsets.all(50),
                    child: ElevatedButton(
                      onPressed: () {
                        SaveChanges();
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
                        AppLocalizations.of(context)!.save_changes,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showCalendar() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (chosenDate != null) {
      setState(() {
        selectedDate = chosenDate;
      });
    }
  }

  void SaveChanges() {
    if (formKey.currentState?.validate() == true) {

    }
  }
}
