import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:style_it_up/details.dart';

class CustomerBooking extends StatefulWidget {
  String serviceId;
  CustomerBooking({this.serviceId});

  @override
  _CustomerBookingState createState() => _CustomerBookingState();
}

class _CustomerBookingState extends State<CustomerBooking> {
  //CalendarController _controller;

  TextEditingController yourFullName = TextEditingController();
  TextEditingController location1 = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  @override
  void initState() {
    print(widget.serviceId);
    super.initState();
    // _controller = CalendarController();
  }

  Future<String> createCustomerBookingDb() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();

    if (yourFullName.text.isNotEmpty &&
        location1.text.isNotEmpty &&
        contactNumber.text.isNotEmpty &&
        _currentdate != null) {
      DocumentReference serviceReference =
          Firestore.instance.document("services/" + widget.serviceId);
      Firestore.instance.collection('CustomerBooking').document().setData({
        "userId": user.uid,
        'yourFullName': yourFullName.text,
        'location': location1.text,
        'contactNumber': contactNumber.text,
        'date': _currentdate,
        'serviceDoc': serviceReference,
        'userEmail': user.email
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Booking Information"),
              content: Text("Successfully Booked"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    yourFullName.clear();
                    location1.clear();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Details()));
                  },
                  child: Text("OKAY"),
                ),
              ],
            );
          });
      return contactNumber.text;
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Booking Information"),
              content: Text("Invalid Data"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OKAY"),
                ),
              ],
            );
          });
    }
  }

  DateTime _currentdate = new DateTime.now();
  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: _currentdate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_seldate != null) {
      setState(() {
        _currentdate = _seldate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formattedate = new DateFormat.yMMMd().format(_currentdate);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Make Booking"),
      ),
      body: Container(
        height: 600,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red[300], Colors.yellow])),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(27.0, 45.0, 10.0, 45.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Your Full Name",
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 4) -
                            95,
                        child: TextField(
                          controller: yourFullName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Location",
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 4) -
                            95,
                        child: TextField(
                          controller: location1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Contact Number",
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width / 4) -
                            95,
                        child: TextField(
                          controller: contactNumber,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Choose your date",
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text('Date: $_formattedate'),
                          IconButton(
                            onPressed: () {
                              _selectdate(context);
                            },
                            icon: Icon(Icons.calendar_today),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      createCustomerBookingDb();
                    },
                    child: Text(
                      "Book",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
