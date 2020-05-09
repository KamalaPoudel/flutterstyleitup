import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_it_up/appointment.dart';
import 'package:style_it_up/customerGallery.dart';
import 'package:style_it_up/profile.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home for customer"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.deepOrange, Colors.orangeAccent])),
              child: Container(
                  child: Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset(
                        "icon.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'STYLEitUP',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              )),
            ),
            ListTile(
              title: Text(
                'My Profile',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myProfile()));
              },
            ),
            ListTile(
              title: Text(
                'My Appointment',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myAppointment()));
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamed('/Welcomepage');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red, Colors.blue[300]])),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/haircare');
              },
              child: Text("Hair Treatment"),
              color: Colors.indigo[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Make Up"),
              color: Colors.indigo[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Body Spa"),
              color: Colors.indigo[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Nail Art"),
              color: Colors.indigo[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerGallery()));
              },
              child: Text("Gallery"),
              color: Colors.indigo[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            // RaisedButton(
            // onPressed: () {},
            //child: Text("Make Appointments"),
            //color: Colors.white70,
            //shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(15.0))),
          ],
        ),
      ),
    );
  }
}
