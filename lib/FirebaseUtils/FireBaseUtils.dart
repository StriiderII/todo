import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/Model/User.dart';
import 'package:todo/Model/Task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: ((snapshot, options) =>
                Task.FromFireStore(snapshot.data()!)),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFirebase(Task task, String uid) {
    var taskCollection = getTasksCollection(uid);
    DocumentReference<Task> taskDocRef = taskCollection.doc();
    task.id = taskDocRef.id;
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uid) {
    return getTasksCollection(uid).doc(task.id).delete();
  }

  static Future<void> editTaskInFirebase(Task task, String uid) {
    final taskReference = getTasksCollection(uid).doc(task.id);
    return taskReference.get().then((taskSnapshot) {
      if (taskSnapshot.exists) {
        return taskReference.update(task.toFireStore());
      } else {
        throw Exception("Task does not exist or you don't have permission to edit it.");
      }
    });
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()),
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }


}
