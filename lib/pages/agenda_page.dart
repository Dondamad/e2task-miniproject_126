import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:task_app/pages/add_task_page.dart';

import '../services/task_service.dart';
import '../theme.dart';
import '../widgets/card_task.dart';
import '../widgets/navigation_drawer.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
          elevation: .6,
          title: const Text("Agenda", style: TextStyle(color: primaryColor)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: primaryColor,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              showAllTask(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget showAllTask() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tasks')
            .where('user_Id', isEqualTo: user.uid)
            .orderBy('complete')
            .orderBy("duedate")

            // .where('complete', isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> myList = [];

          if (snapshot.hasData) {
            var tasks = snapshot.data;

            myList = [
              Column(
                children: tasks!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  var duedate = getCustomFormattedDateTime(
                      data['duedate'].toDate().toString(), 'dd/MM/yyyy');
                  var duetime = getCustomFormattedDateTime(
                      data['duedate'].toDate().toString(), 'HH:mm');

                  return CardTask(
                    title: data['title'].toString(),
                    coures: data['course'],
                    id: doc.id,
                    date: duedate,
                    time: duetime,
                    status: data['complete'],
                  );
                }).toList(),
              ),
            ];
          } else if (snapshot.hasError) {
            myList = [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('ข้อผิดพลาด: ${snapshot.error}'),
              ),
            ];
          } else {
            myList = [
              const SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('อยู่ระหว่างประมวลผล'),
              )
            ];
          }

          return Center(
            child: Column(
              children: myList,
            ),
          );
        });
  }
}
