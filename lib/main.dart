import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:place_picker/widgets/place_picker.dart';
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
  // main class
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userEmail;
  String loggedInUserType;
  GeoPoint location;
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
        location = ds.data['location'];
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
        '/login': (BuildContext context) =>
            LoginScreen(), //keyword to access login screen by main class
        '/registration': (BuildContext context) =>
            RegisterScreen(), //to access registration class
        '/Welcomepage': (BuildContext context) =>
            Welcomepage(), //access welcome page class
        '/home': (BuildContext context) =>
            CustomerHome(), //access customer home class
        '/orghome': (BuildContext context) =>
            OrgHome(), //access organization home class
        '/hairinfo': (BuildContext context) =>
            OrgUploadInfo(), //access organization information upload class
        '/haircare': (BuildContext context) =>
            HairCare(), //access hair care class
        '/details': (BuildContext context) => Details(), //access details class
        '/myBooking': (BuildContext context) =>
            CustomerBooking(), //access customer booking class
        '/seeAppointments': (BuildContext context) =>
            SeeAppointments(), //access see appointments class
        '/commentPage': (BuildContext context) =>
            CommentPage(), //access commentpage class
        '/galleryPage': (BuildContext context) =>
            Gallery(), //access gallery class
        // '/placePicker': (BuildContext context) => PlacePicker(),
      },
    );
  }

  Widget _getLandingPage() {
    //condition to get into customer home page if logged in userType is customer otherwise get into organization home page or else go to welcom page
    if (userEmail != null) {
      if (loggedInUserType == "customer") {
        return CustomerHome();
      } else {
        return OrgHome();
      }
    } else {
      return Welcomepage();
    }
  }
}
