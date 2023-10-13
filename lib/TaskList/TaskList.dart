import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:provider/provider.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/Model/Task.dart';
import 'package:todo/TaskList/TaskWidget.dart';
import 'package:todo/Theme_settings/MyTheme.dart';
import 'package:todo/providers/AuthProvider.dart';
import 'package:todo/providers/ListProvider.dart';
import 'package:todo/providers/AppConfigProvider.dart';

class TaskListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    var provider = Provider.of<AppConfigProvider>(context);

    return Column(
      children: [
        CalendarTimeline(
          initialDate: listProvider.selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            listProvider.setNewSelectedDate(
                date, authProvider.currentUser?.id??"");
          },
          leftMargin: 20,
          monthColor: provider.isDarkMode()
              ? MyTheme.primaryLight
              : MyTheme.primaryLight,
          dayColor:
          provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.blackColor,
          activeDayColor:
          provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.primaryLight,
          activeBackgroundDayColor: provider.isDarkMode()
              ? MyTheme.darkBlackColor
              : MyTheme.whiteColor,
          dotsColor:
          provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.primaryLight,
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Task>>(
            stream: FirebaseUtils.getTasksCollection(authProvider.currentUser?.id ?? "").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var taskList = snapshot.data?.docs.map((doc) => doc.data()).toList();
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return TaskWidget(task: taskList![index]);
                  },
                  itemCount: taskList?.length,
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator(); // Loading indicator
              }
            },
          ),
        ),
      ],
    );
  }
}
