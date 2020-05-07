import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrgHome extends StatefulWidget {
  @override
  _OrgHomeState createState() => _OrgHomeState();
}

class _OrgHomeState extends State<OrgHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Organization Home"),
        leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed('/Welcomepage');
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green, Colors.blue])),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/hairinfo');
              },
              child: Text("Hair Treatment"),
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Make Up"),
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Body Spa"),
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Nail Art"),
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/galleryPage');
              },
              child: Text("Gallery"),
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/seeAppointments');
                },
                child: Text("See Appointments"),
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
          ],
        ),
      ),
    );
  }
}
