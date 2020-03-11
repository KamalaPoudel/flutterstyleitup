import 'package:flutter/material.dart';

class Welcomepage extends StatefulWidget {
  @override
  _WelcomepageState createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
//crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 4),
              Padding(
                padding: EdgeInsets.all(0),
                // padding: const EdgeInsets.fromLTRB(90.0, 80.0, 50.0,30.0),
                child: Image.asset("icon.png"),
              ),
              Text(
                "STYLEitUP",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(16),
                // padding:  EdgeInsets.fromLTRB(70.0, 20.0, 30.0, 20.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text("Login as Customer",
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
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/organizationlogin');
                  },
                  child: Text(
                    "Login as Organization",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
