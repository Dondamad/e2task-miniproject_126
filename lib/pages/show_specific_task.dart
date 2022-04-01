import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_app/pages/edit_task_page.dart';

import 'package:task_app/theme.dart';

import '../services/task_service.dart';

class ShowDetailTask extends StatefulWidget {
  final String id;
  final bool isComplete;
  const ShowDetailTask({Key? key, required this.id, required this.isComplete})
      : super(key: key);

  @override
  State<ShowDetailTask> createState() => _ShowDetailTaskState();
}

class _ShowDetailTaskState extends State<ShowDetailTask> {
  late bool status;

  @override
  void initState() {
    // TODO: implement initState
    status = widget.isComplete;
    super.initState();
  }

  getCustomFormattedDateTime(String givenDateTime, String dateFormat) {
    // dateFormat = 'MM/dd/yy';
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return DateFormat(dateFormat).format(docDateTime);
  }

  // Stream<QuerySnapshot<Object?>>? getdata() {
  //   Stream task = FirebaseFirestore.instance
  //       .collection('Tasks')
  //       .doc(widget.id.toString())
  //       .snapshots();
  //   // .then((DocumentSnapshot value) {
  //   // Map<String, dynamic> data = task.data()! as Map<String, dynamic>;

  //   // }
  //   return task;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title:
              const Text("Task detail", style: TextStyle(color: primaryColor)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: primaryColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: status
                              ? Icon(FontAwesomeIcons.xmark)
                              : Icon(Icons.check),
                          title: status
                              ? Text('Uncompleted')
                              : Text('Mark as Completed'),
                          onTap: () {
                            if (!status) {
                              markAsComplete(widget.id.toString())
                                  .then((value) {
                                setState(() {
                                  status = true;
                                });
                                Navigator.of(context).pop();
                                // Navigator.of(context).pop();
                              });
                            } else {
                              markAsUnComplete(widget.id.toString())
                                  .then((value) {
                                setState(() {
                                  status = false;
                                });
                                Navigator.of(context).pop();
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTask(
                                  id: widget.id.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            // Show Alert Dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: Text(
                                    'Do you want to permanently delete this task?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        deleteTask(widget.id.toString())
                                            .then((value) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();

                                          // Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Delete')),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: show(),
          ),
        ),
      ),
    );
  }

  Widget show() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tasks')
            .doc(widget.id.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0xffffffff),
              color: Color(0xff6146C6),
            ));
          } else {
            var data = snapshot.data!.data();
            var duedate = getCustomFormattedDateTime(
                data['duedate'].toDate().toString(), 'dd/MM/yyyy');

            var duetime = getCustomFormattedDateTime(
                data['duedate'].toDate().toString(), 'HH:mm');

            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: status ? successColor : errorColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      status ? 'Completed' : 'Uncomplete',
                      style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Align(
                //   child: Text(
                //     status ? 'Completed' : 'Uncomplete',
                //   ),
                // ),
                Detaillist(
                    text: data['title'], icon: Icon(Icons.assignment_rounded)),
                SizedBox(height: 12),
                Detaillist(
                    text: data['course'],
                    icon: Icon(FontAwesomeIcons.graduationCap)),
                SizedBox(height: 12),
                Detaillist(text: duedate, icon: Icon(Icons.calendar_today)),
                SizedBox(height: 12),
                Detaillist(text: duetime, icon: Icon(Icons.access_time)),
                SizedBox(height: 12),
                Detaillist(
                    text: data['description'], icon: Icon(Icons.subject)),
              ],
            );
          }
        });
  }
}

class Detaillist extends StatelessWidget {
  final String text;
  final Icon icon;

  const Detaillist({
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            softWrap: true,
            style: bodyText1,
          ),
        ),
      ],
    );
  }
}
