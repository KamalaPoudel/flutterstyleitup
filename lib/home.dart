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
        title: Text("Home"),
        leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed('/Welcomepage');
            }),
      ),
      body: GridView.count(
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
            onPressed: () {},
            child: Text("Gallery"),
            color: Colors.white70,
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
    );
  }
}
