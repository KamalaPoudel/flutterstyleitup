import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String fullName;
  String formattedTimeOfDay;
  String address;
  String phoneNumber;
  String userEmail;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userEmail = user.email;
        print(userEmail);
      });
      getData();
    });
    super.initState();
  }

  void getData() async {
    await Firestore.instance
        .collection('users')
        .document(userEmail)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        fullName = ds.data["fullName"];
        address = ds.data["address"];
        phoneNumber = ds.data["phoneNumber"];
      });
    });
  }

  void createCustomerBookingDb() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();

    if (_currentdate != null && _time != null) {
      DocumentReference serviceReference =
          Firestore.instance.document("services/" + widget.serviceId);
      Firestore.instance.collection('CustomerBooking').document().setData({
        "userId": user.uid,
        'yourFullName': fullName,
        'location': address,
        'contactNumber': phoneNumber,
        'date': _currentdate,
        'time': formattedTimeOfDay,
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
                    Navigator.pop(context);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Details()));
                  },
                  child: Text("OKAY"),
                ),
              ],
            );
          });
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
  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: _currentdate,
        firstDate: DateTime(2020),
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

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        print(_time);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController yourFullName = TextEditingController(text: fullName);
    TextEditingController location1 = TextEditingController(text: address);
    TextEditingController contactNumber =
        TextEditingController(text: phoneNumber);

    String _formattedate = new DateFormat.yMMMd().format(_currentdate);

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    formattedTimeOfDay = localizations.formatTimeOfDay(_time);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Make Booking",
          style: GoogleFonts.notoSans(color: Colors.white, fontSize: 30.0),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red[300], Colors.yellow])),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(27.0, 45.0, 10.0, 45.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("lib/assets/icon.png"),
                    ),
                    Text(
                      "STYLEitUP",
                      style: GoogleFonts.notoSans(
                          fontSize: 20.0, color: Colors.black87),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        "Choose Your Date For Booking",
                        style: GoogleFonts.notoSans(
                            fontSize: 20.0, color: Colors.black87),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Full Name",
                              style: GoogleFonts.notoSans(
                                  fontSize: 18.0, color: Colors.black87),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
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
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Location",
                              style: GoogleFonts.notoSans(
                                  fontSize: 18.0, color: Colors.black87),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
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
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "Contact Number",
                              style: GoogleFonts.notoSans(
                                  fontSize: 18.0, color: Colors.black87),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
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
                            style: GoogleFonts.notoSans(
                                fontSize: 18.0, color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0, top: 15.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Date: $_formattedate',
                                style: GoogleFonts.notoSans(
                                    fontSize: 15.0, color: Colors.black87),
                              ),
                              IconButton(
                                iconSize: 50.0,
                                onPressed: () {
                                  _selectdate(context);
                                },
                                icon: Icon(Icons.calendar_today),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            "Choose your time",
                            style: GoogleFonts.notoSans(
                                fontSize: 18.0, color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0, top: 15.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Time: $formattedTimeOfDay',
                                style: GoogleFonts.notoSans(
                                    fontSize: 15.0, color: Colors.black87),
                              ),
                              IconButton(
                                iconSize: 50.0,
                                onPressed: () {
                                  _selectTime(context);
                                },
                                icon: Icon(Icons.timer),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            createCustomerBookingDb();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Book",
                              style: GoogleFonts.notoSans(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
