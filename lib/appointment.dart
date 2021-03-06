import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyAppointment extends StatefulWidget {
  //MyAppointment Class
  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  String userEmail; //variable declartion

  @override
  void initState() {
    userData();
    super.initState();
  }

  Future<String> userData() async {
    // Helps to identify the current user, whether user is customer or organization
    final FirebaseUser user = await FirebaseAuth.instance
        .currentUser(); // Authenticating the current user through email
    final String email = user.email;
    this.setState(() {
      userEmail = email;
    });

    return email;
  }

  DateTime _currentdate = new DateTime.now();
  Future<Null> _selectdate(BuildContext context) async {
    // _selectdate function to choose date by displaying calendar on the screen
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate:
            _currentdate, // initializing date in calender as current date
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_seldate != null) {
      // condition if user doesnot select any date then the date in calender will be current date
      setState(() {
        _currentdate = _seldate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formattedate = new DateFormat.yMMMd()
        .format(_currentdate); // displaying date in year/month/day format
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Appointment Information",
            style: GoogleFonts.notoSans(fontSize: 25.0, color: Colors.white),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            // Fetching customer booking details from CustomerBooking collection in database,
            stream: Firestore.instance // using user email reference
                .collection('CustomerBooking')
                .where("userEmail", isEqualTo: userEmail)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              if (snapshot.data.documents.length <= 0)
                return Center(
                    child: Text(
                        "You don't have any upcoming appointment")); //if there is no booking details, displaying this message on the screen
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      Timestamp bookingDate = document.data["date"];
                      String formattedBookingDate = DateFormat('MMM dd,yyyy')
                          .format(bookingDate.toDate());
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 15.0, 0, 15.0),
                                  child: Image.asset("lib/assets/icon.png"),
                                ),
                              ),
                              Container(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 15.0, 0, 15.0),
                                    child: Text(
                                      "Upcoming Appointment Date",
                                      style: GoogleFonts.notoSans(
                                          fontSize: 20.0,
                                          color: Colors.black87),
                                    )),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        formattedBookingDate,
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      Text(
                                        document.data[
                                            "time"], // fetching time selected by the customer during booking from database
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 12.0, 8.0, 8.0),
                                child: Container(
                                  width: 165,
                                  height: 45,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      await _selectdate(context);
                                      await Firestore.instance
                                          .collection('CustomerBooking')
                                          .document(document.documentID)
                                          .updateData({
                                        'date': _currentdate
                                      }); //updating new selected date in database
                                    },
                                    child: Text(
                                      "Change Date",
                                      style: GoogleFonts.notoSans(
                                          fontSize: 15.0,
                                          color: Colors.black87),
                                    ),
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 12.0, 8.0, 8.0),
                                child: Container(
                                  width: 180,
                                  height: 45,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      await Firestore.instance
                                          .collection('CustomerBooking')
                                          .document(document.documentID)
                                          .delete(); // deleting the data from CustomerBooking collection in database
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Appointment Detail"),
                                              content: Text(
                                                "You have deleted an appointment",
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 20.0,
                                                    color: Colors.black),
                                              ),
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
                                    },
                                    child: Text(
                                      "Delete Booking",
                                      style: GoogleFonts.notoSans(
                                          fontSize: 15.0,
                                          color: Colors.black87),
                                    ),
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            }));
  }
}
