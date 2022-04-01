import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
  // dateFormat = 'MM/dd/yy';
  final DateTime docDateTime = DateTime.parse(givenDateTime);
  return DateFormat(dateFormat).format(docDateTime);
}

Future<void> markAsComplete(String? id) {
  return FirebaseFirestore.instance
      .collection('Tasks')
      .doc(id)
      .update({'complete': true}).catchError(
          (error) => print("Failed to delete task: $error"));
}

Future<void> markAsUnComplete(String? id) {
  return FirebaseFirestore.instance
      .collection('Tasks')
      .doc(id)
      .update({'complete': false}).catchError(
          (error) => print("Failed to delete task: $error"));
}

Future<void> deleteTask(String? id) {
  return FirebaseFirestore.instance
      .collection('Tasks')
      .doc(id)
      .delete()
      .catchError((error) => print("Failed to delete task: $error"));
}
