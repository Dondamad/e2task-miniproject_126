import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_app/pages/add_task_page.dart';
import 'package:task_app/pages/agenda_page.dart';
import 'package:task_app/services/task_service.dart';
import 'package:task_app/widgets/navigation_drawer.dart';

import '../theme.dart';
import '../widgets/card_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, 23, 59, 59);
    // final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Home", style: TextStyle(color: primaryColor)),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(color: primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome',
                              style: const TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                          Text(user.displayName!,
                              style: const TextStyle(
                                  color: whiteColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            offset: const Offset(12, 26),
                            blurRadius: 50,
                            spreadRadius: 0,
                            color: Colors.grey.withOpacity(.25)),
                      ]),
                      child: CircleAvatar(
                        radius: 25,
                        // backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          user.photoURL!,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 45,
                    // width: size.width,
                    child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Today',
                            style:
                                headline5.copyWith(fontWeight: FontWeight.w500),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      date.toString().split(' ').first,
                      style: bodyText1.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              showTodayTask()
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

  Widget showTodayTask() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tasks')
            .where('user_Id', isEqualTo: user.uid)
            .where('duedate', isLessThanOrEqualTo: date)
            .where('complete', isEqualTo: false)
            .orderBy('duedate')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> myList = [];

          if (snapshot.hasData) {
            var tasks = snapshot.data;

            myList = [
              Column(
                children: tasks!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
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
            return Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('ข้อผิดพลาด: ${snapshot.error}'),
                ),
              ],
            );
            // myList = [
            //   const Icon(
            //     Icons.error_outline,
            //     color: Colors.red,
            //     size: 60,
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.only(top: 16),
            //     child: Text('ข้อผิดพลาด: ${snapshot.error}'),
            //   ),
            // ];
          } else {
            return Center(
              child: Column(
                children: const [
                  SizedBox(
                    child: CircularProgressIndicator(
                      backgroundColor: whiteColor,
                      color: primaryColor,
                    ),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('อยู่ระหว่างประมวลผล'),
                  )
                ],
              ),
            );
            // myList = [
            //   const SizedBox(
            //     child: CircularProgressIndicator(),
            //     width: 60,
            //     height: 60,
            //   ),
            //   const Padding(
            //     padding: EdgeInsets.only(top: 16),
            //     child: Text('อยู่ระหว่างประมวลผล'),
            //   )
            // ];
          }

          return Center(
            child: Column(
              children: myList,
            ),
          );
        });
  }
}
