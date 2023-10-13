import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/DialogUtils/DialogUtils.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/Model/Task.dart';
import 'package:todo/TaskList/TaskDetails.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import 'package:todo/providers/AppConfigProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Theme_settings/MyTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/TaskList/TaskEdit.dart';

class TaskWidget extends StatefulWidget {
  Task task;
  TaskWidget({required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isGreen = false;

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);

    return Container(
      margin: EdgeInsets.all(15),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                var authProvider = Provider.of<AuthProvider>(context, listen: false);
                FirebaseUtils.deleteTaskFromFireStore(
                  widget.task,
                  authProvider.currentUser?.id ?? "",
                ).timeout(
                  Duration(milliseconds: 250),
                  onTimeout: () {
                    print('Deleted');
                    listProvider.getAllTasksFromFireStore(authProvider.currentUser?.id ?? "");
                    Navigator.pop(context);
                  },
                );
              },
              icon: Icons.delete,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              label: 'Delete',
              backgroundColor: Colors.red,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: provider.isDarkMode() ? MyTheme.darkBlackColor : MyTheme.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isGreen ? Colors.green : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                width: 5,
                height: 64,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TaskEdit(task: widget.task),
                            ),
                          );
                        },
                        child: Container(
                          child: Text(
                            widget.task.title ?? '',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: isGreen ? MyTheme.greenLight : (provider.isDarkMode() ? MyTheme.primaryLight : MyTheme.darkBlackColor),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.025,) ,
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TaskEdit(task: widget.task),
                            ),
                          );
                        },
                        child: Container(
                          child: Text(
                            widget.task.description ?? '',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.darkBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isGreen = !isGreen;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: isGreen ? Colors.green : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isGreen
                      ? Text(
                      'Done!',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.darkBlackColor,
                      )
                  )
                      : ImageIcon(
                    AssetImage('assets/images/Icon_awesome_check.png'),
                    color: MyTheme.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
