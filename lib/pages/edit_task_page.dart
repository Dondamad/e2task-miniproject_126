import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/services/task_service.dart';
import 'package:task_app/widgets/button.dart';
import 'package:task_app/widgets/custominputfield.dart';

import '../theme.dart';

class EditTask extends StatefulWidget {
  final String id;
  const EditTask({Key? key, required this.id}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference task = FirebaseFirestore.instance.collection('Tasks');
  final _editFormKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _course = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _date = TextEditingController();
  late bool status;

  Future<void> getdata() async {
    task.doc(widget.id.toString()).get().then((DocumentSnapshot value) {
      Map<String, dynamic> data = value.data()! as Map<String, dynamic>;

      var duedate = getCustomFormattedDateTime(
          data['duedate'].toDate().toString(), 'yyyy-MM-dd');

      var duetime = getCustomFormattedDateTime(
          data['duedate'].toDate().toString(), 'HH:mm');
      _title.text = data["title"];
      _description.text = data['description'];
      _course.text = data['course'];
      _time.text = duetime;
      _date.text = duedate;
      status = data["complete"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    _time.text = '';
    _date.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Add task", style: TextStyle(color: primaryColor)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _editFormKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18,
                ),
                
                CustomInputField(inputController: _title, hintText: 'Title',maxline: 1, label: 'Title',),
                const SizedBox(
                  height: 18,
                ),
                CustomInputField(inputController: _course, hintText: 'Course',maxline: 1, label: 'Course',),
                const SizedBox(
                  height: 18,
                ),
                Text(
          'Duedate',
          style: bodyText1.copyWith(color: darkColor),
        ),
        SizedBox(
          height: 8,
        ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                                      controller: _date,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.calendar_today),
                                    suffixIconConstraints: const BoxConstraints(maxHeight: 30, minWidth: 35),
                                    contentPadding: EdgeInsets.all(18.0),
                                    hintText: 'Date',
                                    hintStyle: bodyText1.copyWith(color: textGrey),
                                    border: OutlineInputBorder(
                                      borderSide:const BorderSide(width: 2),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff6146C6), width: 2),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                      ),
                                      onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:  DateTime.now() //- not to allow to choose before today.
                      lastDate: DateTime(2101));
                              
                                    if (pickedDate != null) {
                                      print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        //               String formattedDate =
                        // DateFormat('dd/MM/yyyy').format(pickedDate);
                                      String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                                      print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement
                              
                                      setState(() {
                      _date.text =
                          formattedDate; //set output date to TextField value.
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                      },
                                    ),
                    ),
                     const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _time,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.access_time),
                         suffixIconConstraints: const BoxConstraints(maxHeight: 30, minWidth: 35),
                          contentPadding: const EdgeInsets.all(18.0),
                          hintText: 'Time',
                          hintStyle: bodyText1.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff6146C6), width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            // initialEntryMode: TimePickerEntryMode.dial,
                            context: context,
                            
                          );
        
                         print(pickedTime);
                          if (pickedTime != null) {

                           DateTime date= DateFormat.jm().parse(pickedTime.format(context).toString());
                            // DateTime date2= DateFormat("hh:mma").parse("6:45PM"); // think this will work better for you
                            // format date
                            // print(DateFormat("HH:mm").format(date));
                            String formattedTime = DateFormat('HH:mm').format(date);
                            
                            // print(DateFormat("HH:mm").format(date2));
                            // String value = 'The text is this';
                            
                           
                            setState(() {
                              _time.text = formattedTime;
                              
                              // print(_time.text); //set the value of text field.
                            });
                          } else {
                            print("Time is not selected");
                          }
                        }
                          
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomInputField(
                  inputController: _description,
                  hintText: 'Description',
                  maxline: 3,
                  label: 'Description',
                ),
                const SizedBox(
                  height: 18,
                ),
                GradientButton(text: 'Save', onPressed: () => {editTask().then((value) {
                  Navigator.pop(context);
                })}),
              ],
            ),
          ),
        ),
    ),
    );
  }
  Future<void> editTask() async {
    // DateTime date = getCustomFormattedDateTime(_date.text, 'yyyy-MM-dd');
    // print(date.toString());
    // DateTime time = getCustomFormattedDateTime(_time.text, 'HH:mm');
    DateTime date1 = DateTime.parse(_date.text+' '+_time.text);
    
    return task.doc(widget.id.toString())
        .update({
          'title': _title.text,
          'course': _course.text,
          'description': _description.text,
          'duedate': date1,
          'complete': status,
          'user_Id': user.uid.toString()
        })
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to add task: $error"));
  }
}
