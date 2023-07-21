import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:schedule1/pages/home_page.dart';
import 'package:schedule1/service/notification.dart';


import 'package:timezone/data/latest.dart' as tz;
import 'package:schedule1/service/theme.dart';
import 'package:schedule1/pages/add_task_bar.dart';
import 'package:schedule1/pages/add_task_bar2.dart';
import 'package:schedule1/pages/add_task_bar3.dart';
import 'package:schedule1/pages/detail3.dart';

import 'package:schedule1/pages/viewapp.dart';
import 'package:schedule1/service/route.dart';
import 'package:schedule1/pages/appointment_page.dart';
import 'package:schedule1/pages/doctor.dart';
import 'package:schedule1/pages/login_page.dart';
import 'package:schedule1/pages/medicine.dart';
import 'package:schedule1/pages/profile.dart';
import 'package:schedule1/pages/registor.dart';




final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
NotificationService _notificationService=NotificationService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initNotification();
 // FirebaseMessaging.onBackgroundMessage(_fir)
  runApp( MyApp());
}



class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Stream<QuerySnapshot>_stream = FirebaseFirestore.instance.collection(
      "doctor").snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    _notificationService.getDevicetoken().then((value){
      print('device token');
      print(value);
    });
    _notificationService.isTokenRefresh();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.light,
      darkTheme: theme.dark,
      // themeMode: ThemeService().theme,

      routes: {
        "/": (context) => login_page(),
        MyRoutes.appointmentRoute: (context) => Home_Page(),
        //MyRoutes.loginRoute:(context)=>login_page(),
        MyRoutes.profile: (context) => ProfilePage(),
        MyRoutes.homeRoute: (context) => home_page1(),
        MyRoutes.appointmentRoute: (context) => Home_Page(),
        //  MyRoutes.detailsroute: (context) => details(),
        MyRoutes.addtaskroute: (context) => AddTaskPage(),
        MyRoutes.doctorroute: (context) => doctor(),
        MyRoutes.addtask2route: (context) => AddTaskPage2(),
        //MyRoutes.details2route: (context) => details2(),
        MyRoutes.viewapproute: (context) => viewapp(),
        MyRoutes.medicineroute: (context) => medicine(),
        MyRoutes.addtask3route: (context) => AddTaskPage3(),
        MyRoutes.details3route: (context) => details3(),
        MyRoutes.registor: (context) => registor_page(),
        //MyRoutes.edit2:(context)=>EditTaskPage2(),

      },

    );
  }


}
