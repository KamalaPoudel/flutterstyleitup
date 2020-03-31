import 'package:flutter/material.dart';

class CustomerHome extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
