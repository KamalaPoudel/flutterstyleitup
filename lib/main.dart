import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/comments.dart';
import 'package:style_it_up/customerbooking.dart';
import 'package:style_it_up/details.dart';
import 'package:style_it_up/haircare.dart';
import 'package:style_it_up/registerscreen.dart';
import 'package:style_it_up/seeappointments.dart';
import 'package:style_it_up/welcomepage.dart';

import 'loginscreen.dart';
import 'organizationlogin.dart';
import 'orghome.dart';
import 'orginfouploadpage.dart';

import 'home.dart';
import 'customerbooking.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userEmail;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        setState(() {
          userEmail = firebaseUser.email;
          print("Logged in user email:- " + userEmail);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getLandingPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/registration': (BuildContext context) => Registrationscreen(),
        '/organizationlogin': (BuildContext context) =>
            OrganizationLoginScreen(),
        '/Welcomepage': (BuildContext context) => Welcomepage(),
        '/home': (BuildContext context) => CustomerHome(),
        '/orghome': (BuildContext context) => OrgHome(),
        '/hairinfo': (BuildContext context) => OrgUploadInfo(),
        '/haircare': (BuildContext context) => HairCare(),
        '/details': (BuildContext context) => Details(),
        '/myBooking': (BuildContext context) => CustomerBooking(),
        '/seeAppointments': (BuildContext context) => SeeAppointments(),
        '/commentPage': (BuildContext context) => CommentPage(),
      },
    );
  }

  Widget _getLandingPage() {
    if (userEmail != null) {
      return CustomerHome();
    } else {
      return Welcomepage();
    }
  }
}
