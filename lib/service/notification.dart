import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import'dart:core';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  static final NotificationService _notificationService =
  NotificationService._internal();
  Future<String>getDevicetoken() async {
    String? token=await messaging.getToken();
    return token!;
  }
  void isTokenRefresh(){
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }
  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initLocalNotification(BuildContext context,RemoteMessage message) async {

    // Android initialization
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');


    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
       );
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,


    );
  }
  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((event) {
         showNotification();
    });
  }
  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await NotificationDetails());
  }

  Future scheduleNotification({int id=0,
     required String title,
  required String body,
      required int payload,
  required DateTime scheduleNotificationDateTime
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(DateTime(scheduleNotificationDateTime.year,scheduleNotificationDateTime.month,scheduleNotificationDateTime.day,scheduleNotificationDateTime.hour,scheduleNotificationDateTime.minute),tz.local).subtract(Duration(minutes:payload )),
      await NotificationDetails(
        android: AndroidNotificationDetails('channelId',
            'channelName',
            'channelDescription',
            //playSound: true,
            //sound: RawResourceAndroidNotificationSound('sound'),
            importance: Importance.max),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      // To show notification even when the app is closed
    );
  }
}




