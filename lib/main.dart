import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/comments.dart';
import 'package:style_it_up/customerbooking.dart';
import 'package:style_it_up/details.dart';
import 'package:style_it_up/haircare.dart';
import 'package:style_it_up/registerscreen.dart';
import 'package:style_it_up/seeappointments.dart';
import 'package:style_it_up/welcomepage.dart';

import 'package:flutter/widgets.dart';

import 'gallery.dart';
import 'loginscreen.dart';
import 'orghome.dart';
import 'orginfouploadpage.dart';

import 'home.dart';
import 'customerbooking.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userEmail;
  String loggedInUserType;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        setState(() {
          userEmail = firebaseUser.email;
          print("Logged in user email:- " + userEmail);
        });
        getUserType();
      }
    });
  }

  void getUserType() async {
    await Firestore.instance
        .collection('users')
        .document(userEmail)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        loggedInUserType = ds.data['userType'];
      });
      // use ds as a snapshot
      print("User type:- " + loggedInUserType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getLandingPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/registration': (BuildContext context) => RegisterScreen(),
        '/Welcomepage': (BuildContext context) => Welcomepage(),
        '/home': (BuildContext context) => CustomerHome(),
        '/orghome': (BuildContext context) => OrgHome(),
        '/hairinfo': (BuildContext context) => OrgUploadInfo(),
        '/haircare': (BuildContext context) => HairCare(),
        '/details': (BuildContext context) => Details(),
        '/myBooking': (BuildContext context) => CustomerBooking(),
        '/seeAppointments': (BuildContext context) => SeeAppointments(),
        '/commentPage': (BuildContext context) => CommentPage(),
        '/galleryPage': (BuildContext context) => Gallery(),
      },
    );
  }

  Widget _getLandingPage() {
    if (userEmail != null) {
      if (loggedInUserType == "customer") {
        return CustomerHome();
      } else {
        return OrgHome();
      }
    } else {
      return LoginScreen();
    }
  }
}
