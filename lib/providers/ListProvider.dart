import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/FirebaseUtils/FireBaseUtils.dart';
import 'package:todo/Model/Task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> taskList = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getAllTasksFromFireStore(String uId) async {
    final QuerySnapshot<Task> querySnapshot =
    await FirebaseUtils.getTasksCollection(uId).get();

    taskList = querySnapshot.docs
        .where((doc) => doc.data().dateTime != null)
        .where((doc) =>
    doc.data().dateTime!.day == selectedDate.day &&
        doc.data().dateTime!.month == selectedDate.month &&
        doc.data().dateTime!.year == selectedDate.year)
        .map((doc) => doc.data())
        .toList();

    taskList.sort((task1, task2) =>
        task1.dateTime!.compareTo(task2.dateTime!));

    notifyListeners();
  }

  void setNewSelectedDate(DateTime newDate, String uId) {
    selectedDate = newDate;
    getAllTasksFromFireStore(uId);
  }
}
