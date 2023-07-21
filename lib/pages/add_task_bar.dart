import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:schedule1/service/notification.dart';
import 'package:schedule1/service/theme.dart';
import 'package:schedule1/widget/button.dart';
import 'package:schedule1/feild/input_feild.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart'as tz;


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
 final TextEditingController _titleController=TextEditingController();
  final TextEditingController _noteController=TextEditingController();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _dateController=TextEditingController();
  final TextEditingController _startController=TextEditingController();
  final TextEditingController _endController=TextEditingController();
  DateTime _selectedDate=DateTime.now();
 String _endTime=DateFormat('hh:mm a').format(DateTime.now()).toString();
 String _startTime=DateFormat('hh:mm a').format(DateTime.now()).toString();
  //String start=DateFormat('yyyy:MM:dd hh:mm').format(DateTime.now()).toString();
  //var outputformat=DateFormat('yyyy:MM:dd hh:mm');
  int _selectedRemind=5;
 DateTime scheduleTime = DateTime.now();
  List<int>remindList=[
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeate="None";
  List<String>repeateList=[
   "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
 final FirebaseAuth _auth=FirebaseAuth.instance;
 final FirebaseFirestore ref = FirebaseFirestore.instance;
// DateTime schedule=DateTime.parse()
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body:Container(
        padding: const EdgeInsets.only(left:20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add appointment",
                  style:subHeadingStyle,
              ),
              MyInputFeild(title: "Appointment Title", hint: "Enter your title",controller:_titleController ,),
              MyInputFeild(title: "Location", hint: "Enter address ",controller: _noteController,),
              MyInputFeild(title: "Name of Doctor", hint: "Enter name of doctor", controller: _nameController,),
              MyInputFeild(title: "Date", hint: DateFormat.yMd().format(_selectedDate),

              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                color: Colors.grey),

                onPressed: (){
                _getDateFromUser();
              },),),
              Row(
                children: [
                  Expanded(
                      child: MyInputFeild(
                        title: "Start Time",
                        hint:_startTime,
                        widget: IconButton(
                          onPressed: (){
                               _getTimeFromUser(isStartTime:true);
                          },
                          icon:Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )
                        ),
                      )),
                  SizedBox(width: 12),
                  Expanded(
                      child: MyInputFeild(
                        title: "End Time",
                        hint:_endTime,
                        widget: IconButton(
                            onPressed: (){
                              _getTimeFromUser(isStartTime: false);
                            },
                            icon:Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            )
                        ),
                      )),
                ],
              ),
              MyInputFeild(title: "Remind", hint: "$_selectedRemind minutes early",
                  widget:DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                        color:Colors.grey),
                    iconSize:32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),
                    onChanged: (String? newValue){
                    setState(() {
                      _selectedRemind=int.parse(newValue!);
                    });
                    },
                    items:remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                        child: Text(value.toString()),
                    );
                  }
                    ).toList()

                  ),
              ),
              MyInputFeild(title: "Repeat" ,hint: "$_selectedRepeate",
                widget:DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down,
                        color:Colors.grey),
                    iconSize:32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),
                    onChanged: (String? newValue){
                      setState(() {
                        _selectedRepeate=newValue!;
                      });
                    },
                    items:repeateList.map<DropdownMenuItem<String>>((String? value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!,style:TextStyle(color: Colors.grey)),
                      );
                    }
                    ).toList()

                ),
              ),
              SizedBox(height: 18,),


                  Row(
                    children: [
                      SizedBox(width:230),
                      MyButton(label: "Create Appointment",
                          onTap:(){
                             _validateDate();
                             //_addTaskToDb();
                             print(_startTime);
                             // print(start);
                              DateFormat format=DateFormat("hh:mm a");
                              DateTime datetime=format.parse(_startTime);
                              print(datetime);
                             print(_selectedDate);
                             print(_selectedRemind);
                             NotificationService().scheduleNotification( scheduleNotificationDateTime: DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day,datetime.hour,datetime.minute), title: _titleController.text, body: _nameController.text, payload:_selectedRemind);
                             print("end");
                             Get.back();
                          }

                      ),
                    ],
                  )

            ],
          ),
        ),
      )
    );
  }
  _validateDate(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty && _nameController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection('appointment').doc().set({
      "title":_titleController.text,
      "location":_noteController.text,
      "doctor name":_nameController.text,
      "Date":DateFormat.yMd().format(_selectedDate),
      "start time":_startTime,
      "end time":_endTime,
      "remind":_selectedRemind,
      "repeat":_selectedRepeate,
      });
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty || _nameController.text.isEmpty){
      Get.snackbar("Required","All feilds are required!");
      snackPosition:SnackPosition.BOTTOM;
      backgroundColor:Colors.white;
      colorText:pinkClr;
      icon:Icon(Icons.warning_amber_rounded);
    }


  }



  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
             Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
            size:20,
            color: Get.isDarkMode? Colors.white:Colors.black
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/img.png"
          ),
        ),
        SizedBox(width:20 ,),
      ],
    );
  }

  _getDateFromUser()async{
    DateTime? _pickerDate=await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015), lastDate: DateTime(2121));
    if(_pickerDate!=null){
      setState((){
      _selectedDate=_pickerDate;
      print(_selectedDate);
      });
    }else{
      print("it is null or something is wrong");
    }
  }
  _getTimeFromUser({required bool isStartTime})async{
   var pickedTime=await _showTimepicker();
   String formatedTime=pickedTime.format(context);
  // DateTime form=pickedTime.format(context);
   if(pickedTime==null){
     print("Time canceld");

   }else if(isStartTime==true){
     setState(() {
       _startTime = formatedTime;
       //start=outputformat.format(pickedTime);

     });
   }else if(isStartTime==false){
     setState(() {
       _endTime=formatedTime;
     });


   }
  }
  _showTimepicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),

),
    );
  }

}
