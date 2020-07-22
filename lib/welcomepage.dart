import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcomepage extends StatefulWidget {
  //welcome page class
  @override
  _WelcomepageState createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green, Colors.blue])),
          child: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
//crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
                    Padding(
                      padding: EdgeInsets.all(0),
                      // padding: const EdgeInsets.fromLTRB(90.0, 80.0, 50.0,30.0),
                      child: Image.asset("lib/assets/icon.png"),
                    ),
                    Text(
                      "STYLEitUP",
                      style: GoogleFonts.notoSans(
                          fontSize: 20.0, color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(16),
                      // padding:  EdgeInsets.fromLTRB(70.0, 20.0, 30.0, 20.0),
                      child: RaisedButton(
                        onPressed: () {
                          //page route to go into login page
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Text("Login",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      //padding:EdgeInsets.fromLTRB(70.0, 1.0, 30.0, 10.0 ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
