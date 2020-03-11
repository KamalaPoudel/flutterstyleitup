import 'package:flutter/material.dart';
import 'package:style_it_up/customerbooking.dart';
import 'package:style_it_up/registerscreen.dart';
import 'package:style_it_up/welcomepage.dart';

import 'loginscreen.dart';
import 'organizationlogin.dart';
import 'orghome.dart';
import 'orginfouploadpage.dart';

import 'home.dart';
import 'customerbooking.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcomepage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/registration': (BuildContext context) => Registrationscreen(),
        '/organizationlogin': (BuildContext context) =>
            OrganizationLoginScreen(),
        '/home': (BuildContext context) => CustomerHome(),
        '/orghome': (BuildContext context) => OrgHome(),
        '/hairinfo': (BuildContext context) => OrgUploadInfo(),
        '/myBooking': (BuildContext context) => CustomerBooking(),
      },
    );
  }
}
