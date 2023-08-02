import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripedemo/parking/Home.dart';
import 'package:stripedemo/parking/info.dart';
import 'package:stripedemo/users/creatNewPassword.dart';
import 'package:stripedemo/users/editProfile.dart';
import 'package:stripedemo/users/signin.dart';
import 'package:stripedemo/users/signup.dart';
import 'package:timezone/data/latest_10y.dart';

import 'SplashScreen.dart';
import 'payment/homescreen.dart';
import 'navigations/nav_bottom.dart';
import 'navigations/nav_tab.dart';

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
  "pk_test_51NVcaDEr6asoNU6n40KYDYQcBFtzaxIClmVi56leFMRplwp7UwzUtnqVOjxiadjEZkP71Lf73qWaHDnryztFSyiq00LwXFxRrS";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  initializeTimeZones();

  AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true
  );

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,

  );

  bool? initialized = await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        log(response.payload.toString());
      }
  );

  log("Notifications: $initialized");

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkMobile',
      // home: Home(),
      debugShowCheckedModeBanner: false,

      //  home: Notification(),
      routes: {
        "/": (context) {
          return SplashScreen();
        },
        "/signin": (context) {
          return Signin();
        },
        "/signup": (context) {
          return Signup();
        },
        "/resetPwd": (context) {
          return CreatNewPassword();
        },
        "/home": (context) {
          return Home();
        },
        "/home/update": (context) {
          return EditProfilePage();
        },
        "/homeBottom": (context) {
          return NavigationBottom();
        },
        "/homeTab": (context) {
          return NavigationTab();
        },
        "/home/info": (context) {
          return Info();
        },
        "/home/payment": (context) {
          return HomeScreen();
        },

      },
    );
  }
}
