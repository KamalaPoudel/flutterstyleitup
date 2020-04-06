import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              onPressed: () {},
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
