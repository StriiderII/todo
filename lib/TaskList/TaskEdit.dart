import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/Model/Task.dart';
import 'package:todo/Model/User.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/TaskList/AddTaskBottomSheet.dart';
import 'package:todo/providers/AppConfigProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/providers/AuthProvider.dart';

class TaskEdit extends StatefulWidget {
  final Task task;

  TaskEdit({required this.task});

  @override
  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late ListProvider listProvider;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current task's values
    titleController = TextEditingController(text: widget.task.title ?? '');
    descriptionController =
        TextEditingController(text: widget.task.description ?? '');
  }

  @override
  void dispose() {
    // Dispose of the text controllers when the widget is disposed
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveTask() {
    DialogUtils.showLoading(context, 'Saving...');
    widget.task.title = titleController.text;
    widget.task.description = descriptionController.text;
    widget.task.dateTime = selectedDate;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isUserLoggedInBefore()) {

      final userId = authProvider.currentUser!.id;


      FirebaseUtils.editTaskInFirebase(widget.task, userId!)
          .then((_) {
        DialogUtils.hideLoading(context);
        Navigator.of(context).pop();
      })
          .catchError((error) {
        DialogUtils.hideLoading(context);
        print('Error editing task: $error');
      });
    } else {
     
      DialogUtils.hideLoading(context);
      print('User is not logged in');
    }
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


  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 300,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,) ,
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
                  child: InkWell(  onTap: () {
                    showCalendar();
                  },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.25,) ,
                ElevatedButton(
                  onPressed: () {
                    saveTask();
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
                    'Save changes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
